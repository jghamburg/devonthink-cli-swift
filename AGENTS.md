# AGENTS.md — devonthink-cli-swift

AI agent guidance for working in this repository.

---

## What this project is

A native Swift CLI (`dt`) for DEVONthink 4 using `ScriptingBridge.framework`.
It replaces a Node.js/JXA reference implementation (`devonthink-cli/`, sibling directory —
**read-only, never modify**).

**Installed binaries:** `dt` and `dt-cli` (symlink → `dt`). No binary named `devonthink`.

---

## Build and install

```sh
# Debug build (fast, for compiler checks)
swift build

# Release build + install to ~/.local/bin
make install

# Remove installed binaries
make uninstall
```

Always run `make install` before benchmarking — it builds release and installs the correct binary.

---

## Benchmarking

```sh
# dt vs Node.js reference (run Node.js binary by its full path — see note below)
hyperfine --warmup 3 --runs 10 'dt search liteLLM'

# Per-result scaling
hyperfine --runs 10 'dt search liteLLM --limit 1'
hyperfine --runs 10 'dt search liteLLM --limit 50'
```

> `make install` installs `dt` to `~/.local/bin/dt`. There is no `~/.local/bin/devonthink`
> Swift binary. The Node.js reference lives at `../devonthink-cli/` and must be invoked
> via its own path when doing comparison benchmarks.

Current result: `dt search` runs in ~180ms — **5.09× faster** than Node.js reference (~917ms).

---

## Key source files

| File | Purpose |
|------|---------|
| `Sources/dt/main.swift` | Entry point |
| `Sources/DevonthinkCore/Bridge/RecordBatchFetcher.swift` | `pALL` batch fetch — 1 AE per record instead of 12–18 |
| `Sources/DevonthinkCore/Output/Output.swift` | `formatRecord`, `formatRecordSummary`, `_isoFormatter` singleton |
| `Sources/DevonthinkCore/Commands/GetRecordProperties.swift` | Full property set; reuses batch dict from `batchFetchProperties` |
| `Sources/DevonthinkCore/Lookup/RecordResolver.swift` | Resolves UUID / x-devonthink-item:// / numeric ID / path |
| `Sources/DevonthinkBridge/DEVONthink.m` | ObjC stubs; `codeForPropertyNameData__` table is the **authoritative FourCC reference** |
| `Sources/DevonthinkCore/Bridge/DEVONthink.h` | Generated ScriptingBridge header — **do not modify** |

---

## ScriptingBridge critical rules

### Every `.get()` call = one Apple Event ≈ 10ms

Never access properties individually in a loop. Always use `batchFetchProperties` first:

```swift
let batch = batchFetchProperties(record)   // 1 AE
if !batch.isEmpty {
    // read all properties from `batch` using batchString/batchInt/batchBool/batchDate
} else {
    // fallback: individual accessors
}
```

### `pALL` batch fetch

`(record as SBObject).property(withCode: 0x70414c4c).get()` returns all record properties
in one Apple Event. ScriptingBridge returns **string-keyed** `[String: Any]` dicts
(AppleScript property names), NOT FourCC-keyed. The dual-key helpers in
`RecordBatchFetcher.swift` handle both.

### FourCC constants — always verify against DEVONthink.m

The authoritative source for FourCC↔name mappings is the `codeForPropertyNameData__` table
in `Sources/DevonthinkBridge/DEVONthink.m`. Three constants were wrong in the original
implementation and caused silent failures. Always cross-check before adding new ones.

Common confirmed FourCCs:

| Property | FourCC | Hex |
|---|---|---|
| `uuid` | `'UUID'` | `0x55554944` |
| `name` | `'pnam'` | `0x706e616d` |
| `id` | `'ID  '` | `0x49442020` |
| `location` | `'DTlo'` | `0x44546c6f` |
| `path` | `'ppth'` | `0x70707468` |
| `recordType` | `'DTrp'` | `0x44547270` |
| `size` | `'ptsz'` | `0x7074737a` |
| `score` | `'DTso'` | `0x4454736f` |
| `creationDate` | `'DTcr'` | `0x44546372` |
| `modificationDate` | `'DTmo'` | `0x44546d6f` |
| `additionDate` | `'DTad'` | `0x44546164` |
| `flag` | `'DTst'` | `0x44547374` |
| `unread` | `'DTur'` | `0x44547572` |
| `locking` | `'DTlc'` | `0x44546c63` |
| `wordCount` | `'DTwc'` | `0x44547763` |
| `characterCount` | `'DTcc'` | `0x44546363` |
| `tags` | `'tags'` | `0x74616773` |
| `comment` | `'DTco'` | `0x4454636f` |
| `url` | `'pURL'` | `0x7055524c` |
| `referenceURL` | `'rURL'` | `0x7255524c` |
| `rating` | `'DTrt'` | `0x44547274` |
| `label` | `'DTla'` | `0x44546c61` |
| `kind` | `'DTki'` | `0x44546b69` |
| `plainText` | `'DTpl'` | `0x4454706c` |
| `excludeFromChat` | `'DTxi'` | `0x44547869` |
| `excludeFromClassification` | `'DTxc'` | `0x44547863` |
| `excludeFromSearch` | `'DTxs'` | `0x44547873` |
| `excludeFromSeeAlso` | `'DTxa'` | `0x44547861` |
| `excludeFromTagging` | `'DTxt'` | `0x44547874` |
| `excludeFromWikiLinking` | `'DTxw'` | `0x44547877` |

### SBElementArray — call as functions, not properties

```swift
app.databases()        // ✅
app.selectedRecords()  // ✅
group.children()       // ✅
app.databases          // ❌ silently returns nil when cast to array
```

### App methods are non-optional

```swift
app.search(...)   // ✅
app.search?(...)  // ❌
```

### Enum constants — no dot prefix

```swift
DEVONthinkSearchComparisonNoCase   // ✅
.DEVONthinkSearchComparisonNoCase  // ❌
```

### `getRecord*` methods — NOT renamed by Swift importer

```swift
app.getRecordWithId(numericId, in: nil as AnyObject?)    // ✅
app.getRecord(withId:in:)                                // ❌ does not exist
```

### `url` property is lowercase

```swift
record.url   // ✅
record.URL   // ❌
```

### `currentDatabase` / `currentGroup` are properties, not methods

```swift
app.currentDatabase  // ✅ (no ())
app.currentGroup     // ✅ (no ())
```

---

## Formatter conventions

- **List commands** (`search`, `list-group-content`, `get-selected-records`): use `formatRecordSummary` — 12 fields
- **Single-record detail commands** (`get-record-by-identifier`, `lookup-record`): use `formatRecord` — 18 fields
- **`get-record-properties`**: use `formatRecordProperties` — 18 + 11 extra fields, all from the same batch dict
- **`_isoFormatter`**: module-level singleton in `Output.swift` — never allocate `ISO8601DateFormatter()` inline

---

## Commit convention (required)

This project uses [Conventional Commits](https://www.conventionalcommits.org/) — semantic-release
parses commit messages to determine version bumps and generate the changelog.

| Prefix | Effect | Example |
|--------|--------|---------|
| `feat:` | minor version bump | `feat: add export command` |
| `fix:` | patch version bump | `fix: handle empty search results` |
| `BREAKING CHANGE:` (in footer) | major version bump | `feat!: rename --limit to --max-results` |
| `chore:`, `docs:`, `refactor:`, `perf:` | no release | `chore: update dependencies` |

**Never use the real email address in commits.** The repo is configured to use:
```
jghamburg@users.noreply.github.com
```

---

## Adding a new command

1. Create `Sources/DevonthinkCore/Commands/MyCommand.swift`
2. Register it in `Sources/DevonthinkCore/Commands/DTCommand.swift` subcommands array
3. For any record property reads, use `batchFetchProperties` + batch helpers; never individual accessors in a loop
4. Verify FourCC values against `DEVONthink.m` before using them

---

## CI/CD pipeline

`.github/workflows/ci.yml` — runs `swift build` on every push and PR (`macos-15`, arm64).

`.github/workflows/release.yml` — runs `npx semantic-release` on every push to `main`.
Triggered only by `feat:` or `fix:` commits (per `.releaserc.json`). Requires `GITHUB_TOKEN`
with `permissions: contents: write`. Semantic-release will:
- Determine the next version from commit messages
- Update `Sources/DevonthinkCore/Version.swift` via `sed`
- Commit the version bump with `[skip ci]` to prevent a loop
- Build the arm64 release binary and attach it as a GitHub Release asset
- Publish a changelog

**Do not manually edit `Sources/DevonthinkCore/Version.swift`** — it is managed by semantic-release.

---

## What NOT to do

- Do NOT modify `Sources/DevonthinkCore/Bridge/DEVONthink.h` (generated file)
- Do NOT modify anything in `../devonthink-cli/` (read-only Node.js reference)
- Do NOT call `record.id()` individually in the batch path — use `batchInt(b, 0x49442020, "id")`
- Do NOT allocate `ISO8601DateFormatter()` per record — use `_isoFormatter`
- Do NOT add a binary named `devonthink` — the only binaries are `dt` and `dt-cli`

---

## Documentation to update after any change cycle

- `CONTEXT.md` — progress table, project structure if files added/removed
- `README.md` — if install or command surface changes
- `AGENTS.md` — if build conventions, FourCC table, or architectural patterns change
- `docs/2026-04-14-runtime-optimization-plan.md` — after any performance work with new benchmark results
