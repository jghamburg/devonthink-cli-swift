# Runtime Optimization Plan — dt Swift CLI

**Date:** 2026-04-14  
**Status: IN PROGRESS**

## Results Summary

Node.js reference baseline: **~917ms** (`devonthink search liteLLM`, 10 runs, mean).

| Phase | `dt search` mean | vs Node.js (~917ms) |
|-------|-----------|------------|
| Baseline | 972ms | 0.94× **slower** |
| Phase 1+3 (12-field summary, ISO8601 cache, isUUID fix) | 670ms | 1.37× faster |
| Phase 2 (pALL batch fetch, dual-key lookup, FourCC fixes) | 215ms | 4.27× faster |
| Phase 4 (`record.id()` from batch; `get-record-properties` batch reuse) | **180ms** | **5.09× faster** |

**Search total: −792ms wall time (−81%).**

| Command | Phase 4 mean |
|---------|-------------|
| `dt search liteLLM` (5 results) | 180ms |
| `dt get-record-properties <uuid>` | 169ms |

> **Benchmark note:** `make install` writes the Swift binary to `~/.local/bin/devonthink`,
> overwriting any Node.js binary at that path. When benchmarking against the Node.js
> reference, run it explicitly via its project path or a dedicated alias — do NOT rely on
> `devonthink` in PATH after `make install`.

---

## Root Cause (confirmed)

Every property read on a `DEVONthinkRecord` via ScriptingBridge calls `SBObject.get()`,
which sends a synchronous Apple Event IPC round-trip to DEVONthink (~10ms each).

`formatRecord` (used for all list commands) fetched **18 properties per record**.  
TypeScript `search` fetched **12 properties per record** inside a single `osascript`
process where JXA caches values within the script context.

With 5 search results: **90 AEs (Swift) vs 60 AEs (JXA)** → Swift was slower despite
being a native binary.

---

## Changes Applied

### Phase 1 — Slim list formatter (`formatRecordSummary`)
**Files:** `Output.swift`, `Search.swift`, `ListGroupContent.swift`, `GetSelectedRecords.swift`

- Added `formatRecordSummary` with 12 fields (matching TypeScript search output)
- Removed from list views: `comment`, `url`, `referenceURL`, `rating`, `label`, `database`
- Single-record commands (`GetRecordProperties`, `GetRecordByIdentifier`, `LookupRecord`) keep full `formatRecord`
- **Result: 972ms → 670ms (−31%)**

### Phase 3 — Hot-path fixes
**Files:** `Output.swift`, `RecordResolver.swift`

- `ISO8601DateFormatter` singleton — was allocated fresh per record per date field
- `isUUID` manual check — replaced regex compilation on every call with O(1) char scan

### Phase 2 — `pALL` batch property fetch
**Files:** `Sources/DevonthinkCore/Bridge/RecordBatchFetcher.swift`, `Output.swift`

- `batchFetchProperties(_ record:)` calls `(record as SBObject).property(withCode: 0x70414c4c).get()`
- Returns all record properties in **1 Apple Event** instead of 12–18 individual gets
- **Dual-key lookup** (`NSNumber` FourCC key OR `String` name key): ScriptingBridge returns
  string-keyed dictionaries, not FourCC-keyed — the dual lookup handles both
- **Result: 670ms → 215ms (−68%)**

#### FourCC errors found and fixed

Three constants in the original implementation were wrong, causing silent lookup failures:

| Property | Wrong FourCC | Correct FourCC |
|----------|-------------|----------------|
| `recordType` | `0x44546d74` (`'DTmt'` = MIMEType) | `0x44547270` (`'DTrp'`) |
| `size` | `0x70747377` (`'ptsw'`) | `0x7074737a` (`'ptsz'`) |
| `score` | `0x44546f73` (`'DTos'`) | `0x4454736f` (`'DTso'`) |

FourCCs confirmed from `Sources/DevonthinkBridge/DEVONthink.m` `codeForPropertyNameData__` table.

---

### Phase 4 — `record.id()` from batch + `get-record-properties` batch reuse
**Files:** `RecordBatchFetcher.swift`, `Output.swift`, `GetRecordProperties.swift`

#### `record.id()` from batch dict

`record.id()` was still firing one individual Apple Event per record even in the batch path
(it was called directly in `formatRecordFromBatch` and `formatRecordSummaryFromBatch`).

- Added `kPropId: 0x49442020` (`'ID  '`) to `RecordBatchFetcher.swift`
- Both `formatRecordFromBatch` and `formatRecordSummaryFromBatch` now use:
  ```swift
  let rid = batchInt(b, 0x49442020, "id")
  dict["id"] = rid != 0 ? rid : record.id()
  ```
- Saves 1 AE × N results per list command.

#### `get-record-properties` batch dict reuse

Previously `formatRecordProperties` called `formatRecord` (which ran `batchFetchProperties`)
and then fired **11 additional individual AEs** for the extra fields — all of which are
already in the pALL dict.

Restructured so `formatRecordProperties` calls `batchFetchProperties` **once** and then:
- Passes the batch to `formatRecordFromBatch` for the base 18 fields (no second pALL call)
- Reads all 11 extra fields from the same batch dict via `batchBool`/`batchDate`/`batchInt`/`batchString`
- Falls back to `record.plainText` individual AE only if `plainText` is absent from batch
  (large content records may omit it from pALL)
- Fixed `ISO8601DateFormatter()` on `additionDate` line — now uses the `_isoFormatter` singleton

Also added `batchBool` helper and 13 new FourCC constants to `RecordBatchFetcher.swift`:

| Property | FourCC | Hex |
|---|---|---|
| `id` | `'ID  '` | `0x49442020` |
| `additionDate` | `'DTad'` | `0x44546164` |
| `flag` | `'DTst'` | `0x44547374` |
| `unread` | `'DTur'` | `0x44547572` |
| `locking` | `'DTlc'` | `0x44546c63` |
| `wordCount` | `'DTwc'` | `0x44547763` |
| `characterCount` | `'DTcc'` | `0x44546363` |
| `excludeFromChat` | `'DTxi'` | `0x44547869` |
| `excludeFromClassification` | `'DTxc'` | `0x44547863` |
| `excludeFromSearch` | `'DTxs'` | `0x44547873` |
| `excludeFromSeeAlso` | `'DTxa'` | `0x44547861` |
| `excludeFromTagging` | `'DTxt'` | `0x44547874` |
| `excludeFromWikiLinking` | `'DTxw'` | `0x44547877` |
| `plainText` | `'DTpl'` | `0x4454706c` |

`formatRecordFromBatch` and `_isoFormatter` promoted from `private` to `internal` so
`GetRecordProperties.swift` (same module, different file) can reference them.

**Result: `get-record-properties` 13 AEs → 1–2 AEs. Measured: 169ms mean.**
**Search: 215ms → 179ms (−17%) from eliminating `record.id()` individual AE.**

---

## Remaining Items (optional future work)

### Phase 5 — `record.database` — still 2 individual AEs
`resolvedDatabase(record.database)` + `.name` in `formatRecordFromBatch` line ~121 still fire
individual AEs. The `database` object itself can be read from batch (FourCC `'DTkb'` = `0x44546b62`),
but its `.name` property still requires a separate AE against the database object.
Minor saving possible; low priority.

### Phase 6 — Output buffering
`print()` per key-value in human mode causes a syscall per line.
Low impact for small result sets (< 50 records). Could batch into a single `print` call.

### Phase 7 — Build caching
- [ ] Migrate `unsafeFlags` bridging header import in `Package.swift` to a proper SPM
  `swiftSettings` mechanism — `unsafeFlags` disables SPM incremental build caching for
  the entire `DevonthinkCore` target, causing full recompiles on every change.
  (Build-time only; no runtime effect.)

### Phase 8 — Remove Mirror reflection
- [ ] Replace `Mirror(reflecting:)` in `unwrapOptional` (`BridgeValue.swift`) with a
  direct optional check — now that pALL batch fetch is the primary path, this is rarely
  exercised but still worth cleaning up.

---

## Measurement Protocol

```sh
# dt and dt-cli are the only installed Swift binaries — no PATH collision risk.
hyperfine --warmup 3 --runs 10 'dt search liteLLM' '<path-to-node-devonthink-cli> search liteLLM'

# Per-result scaling:
hyperfine --runs 10 'dt search liteLLM --limit 1'
hyperfine --runs 10 'dt search liteLLM --limit 50'
```

**Date:** 2026-04-14  
**Baseline benchmarks (hyperfine, 10 runs):**

| Binary | Mean | σ |
|--------|------|---|
| `dt search liteLLM` (Swift/ScriptingBridge) | 939.2 ms | ±20.0 ms |
| `devonthink search liteLLM` (Node.js/osascript) | 907.4 ms | ±9.1 ms |

Swift is ~32ms **slower** than the Node.js reference despite being a native binary.

---

## Root Cause

Every property read on a `DEVONthinkRecord` via ScriptingBridge calls `SBObject.get()`,
which sends a synchronous Apple Event IPC round-trip to DEVONthink.

`formatRecord` (used for all list commands) fetches **18 properties per record**.  
TypeScript `search` fetches **12 properties per record** inside a single `osascript`
process where JXA caches values within the script context.

With 5 search results: **90 vs 60 Apple Event round-trips** ≈ 30 extra IPCs ≈ **+32ms**.

### Extra fields Swift fetches that TypeScript does not (in search context)

| Field | Always fetched | Shown when empty |
|-------|---------------|-----------------|
| `database` | ✓ | ✓ always |
| `label` | ✓ | ✓ always (always 0) |
| `rating` | ✓ | ✓ always (always 0) |
| `referenceURL` | ✓ | ✓ always |
| `url` | ✓ | suppressed |
| `comment` | ✓ | suppressed |
| `tags` | ✓ | suppressed (but AE fired) |

---

## Action Items

### Phase 1 — Reduce Apple Events per record for list commands  ✅ in progress
**Expected gain: ~30ms (closes gap to TypeScript)**

- [x] Add `formatRecordSummary` (12-field) to `Output.swift`
  - Fields: uuid, name, id, path, location, recordType, kind,
    creationDate, modificationDate, tags, size, score
  - Drops from list views: comment, url, referenceURL, rating, label, database
- [x] Cache `ISO8601DateFormatter` as module-level singleton in `Output.swift`
  (was allocated fresh per record per date field — ICU init overhead)
- [ ] Wire `formatRecordSummary` into list commands:
  - `Search.swift` → replace `formatRecord` with `formatRecordSummary`
  - `ListGroupContent.swift` → replace `formatRecord` with `formatRecordSummary`
  - `GetSelectedRecords.swift` → replace `formatRecord` with `formatRecordSummary`
- Single-record commands (`GetRecordProperties`, `GetRecordByIdentifier`, `LookupRecord`)
  keep full `formatRecord` — they are detail views where all fields are useful.

### Phase 2 — `pALL` batch property fetch (1 Apple Event per record)
**Expected gain: additional ~50ms for 5 results; scales linearly with result count**

ScriptingBridge's `SBObject.propertyWithCode(0x70414c4c)` requests the Apple Script
`pALL` / `pProperties` property, returning ALL record properties in a **single Apple Event**
as an `NSDictionary` keyed by `NSNumber` (FourCC).

Confirmed FourCCs from `Sources/DevonthinkBridge/DEVONthink.m`:

| Property | FourCC (hex) | FourCC (chars) |
|----------|-------------|----------------|
| uuid | `0x55554944` | `'UUID'` |
| name | `0x706e616d` | `'pnam'` |
| location | `0x44546c6f` | `'DTlo'` |
| path | `0x70707468` | `'ppth'` |
| kind | `0x44546b69` | `'DTki'` |
| tags | `0x74616773` | `'tags'` |
| size | `0x70747377` | `'ptsz'` |
| score | `0x44546f73` | `'DTso'` |
| creationDate | `0x44546372` | `'DTcr'` |
| modificationDate | `0x44546d6f` | `'DTmo'` |
| recordType | `0x44546d74` | `'DTmt'` |
| comment | `0x4454636f` | `'DTco'` |
| url | `0x7055524c` | `'pURL'` |
| referenceURL | `0x7255524c` | `'rURL'` |
| rating | `0x44547274` | `'DTrt'` |
| label | `0x44546c61` | `'DTla'` |
| database | via `record.database()` | — |

- [ ] Create `Sources/DevonthinkCore/Bridge/RecordBatchFetcher.swift`
  - `func batchProperties(_ record: DEVONthinkRecord) -> [UInt32: Any]`
  - Calls `(record as SBObject).propertyWithCode(0x70414c4c).get()`
  - Returns empty dict on failure (triggers fallback to individual accessors)
- [ ] Update `formatRecordSummary` to use batch fetch first, individual accessors as fallback
- [ ] Update `formatRecord` (full) to use batch fetch first, individual accessors as fallback

### Phase 3 — Hot-path code fixes  ✅ in progress
**Low individual impact, zero risk**

- [x] `ISO8601DateFormatter` singleton (done in Phase 1 above)
- [ ] Replace regex-based `isUUID` in `RecordResolver.swift` with manual O(1) check
  - Current: `s.range(of: pattern, options: .regularExpression)` — compiles regex per call
  - Fix: check `s.count == 36`, hyphens at positions 8/13/18/23, hex chars elsewhere
- [ ] Remove `Mirror(reflecting:)` from `unwrapOptional` in `BridgeValue.swift`
  - `Mirror` is slow reflection; replace with `Optional<Any>` pattern match for the common path

### Phase 4 — Build caching (compile-time, not runtime)
- [ ] Migrate `unsafeFlags` bridging header import in `Package.swift` to a proper SPM
  `swiftSettings` mechanism — `unsafeFlags` disables SPM incremental build caching for
  the entire `DevonthinkCore` target, causing full recompiles on every change.

---

## Measurement Protocol

```sh
# After each phase:
hyperfine --warmup 3 --runs 10 'dt search liteLLM'
hyperfine --warmup 3 --runs 10 'devonthink search liteLLM'

# Per-result scaling check:
hyperfine --runs 10 'dt search liteLLM --limit 1'
hyperfine --runs 10 'dt search liteLLM --limit 50'
```

Target: `dt` ≤ `devonthink` (Swift native binary should be faster than Node.js + osascript).
