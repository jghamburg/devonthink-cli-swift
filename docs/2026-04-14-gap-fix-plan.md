# Gap Fix Plan — 2026-04-14

> Fixes all gaps identified in the cross-check of Swift implementation vs TypeScript requirements.

## Status Key
- ⬜ Pending
- 🔄 In Progress  
- ✅ Done

---

## 1. `Output.swift` — Fix `formatRecord` and `formatDatabase` (HIGH #1, #2) ✅

- **`formatDatabase`**: Added `filename`, `encrypted`, `readOnly`, `spotlightIndexing`, `versioning`, `revisionProof`, `comment`
- **`formatRecord`**: Added `size`, `kind`, `referenceURL`, `rating`, `label`, `score`. Renamed key `"type"` → `"recordType"`
- **Discovery**: Header declares `SpotlightIndexing` but Swift renames it to `spotlightIndexing` (Swift 3 rename)

## 2. `RecordResolver.swift` — Fix `x-devonthink-item://` handling (HIGH #5) ✅

- Strip `x-devonthink-item://` prefix → extract UUID portion
- Try UUID lookup (uppercased), then URL-decode + UUID lookup, then `lookupRecordsWithURL` fallback with referenceURL verification

## 3. `GetRecordProperties.swift` — Return full property set (HIGH #3) ✅

- Added dedicated `formatRecordProperties()` function extending `formatRecord()`
- Fields added: `additionDate`, `flag`, `unread`, `locked` (from `locking`), `wordCount`, `characterCount`, all 6 `excludeFrom*` flags
- `plainText` truncated to 1000 chars, only for text types (markdown, text, formatted note, rtf, rtfd)

## 4. `Search.swift` — Add missing parameters (HIGH #4) ✅

- Added: `--comparison`, `--record-type`, `--limit`, `--database`, `--use-current-group`, `--group-id`, `--group-path`
- Post-search `recordType` filtering, limit (default 50), `totalCount` in JSON output
- Validation: `--group-id`/`--group-path` require `--database`; `--use-current-group` conflicts with explicit group options
- Added shared `resolveDatabase()` and `parseSearchComparison()` helpers
- Made `printJSON()` public (was private) for custom output formatting

## 5. `GetSelectedRecords.swift` — Return empty array instead of error ✅

- Removed `throw CliError.noSelection` on empty selection → returns empty array

## 6. `GetRecordContent.swift` — Content-type-aware retrieval (MEDIUM #6) ✅

- RTF/RTFD → `richText` (fallback to `plainText`)
- HTML/webarchive → `source` (fallback to `plainText`)
- All others → `plainText`

## 7. `UpdateRecordContent.swift` — Content-type-aware update (MEDIUM #7) ✅

- HTML/webarchive → sets `source`
- All others → sets `plainText`
- Reports `updatedProperty` in output (either `"source"` or `"plainText"`)

## 8. `SetRecordProperties.swift` — Add missing properties (MEDIUM #8) ✅

- Added: `--locked`/`--unlocked` (maps to `locking` property)
- Added all exclusion flag pairs: `--exclude-from-chat`/`--include-in-chat`, `--exclude-from-classification`/`--include-in-classification`, `--exclude-from-search`/`--include-in-search`, `--exclude-from-see-also`/`--include-in-see-also`, `--exclude-from-tagging`/`--include-in-tagging`, `--exclude-from-wiki-linking`/`--include-in-wiki-linking`
- `excludeFromTagging` validates record is group/smart group; skips with reason if not
- Tracks `updated`/`skipped` arrays in output

## 9. `Classify.swift` — Add missing parameters (MEDIUM #9) ✅

- Added: `--comparison` (data/tags), `--tags` flag, `--database`
- Added shared `parseComparisonType()` helper
- Fixed unnecessary `compactMap` warning

## 10. `Compare.swift` — Add two-record mode and parameters (MEDIUM #10) ✅

- Added: `--compare-with` for two-record comparison, `--comparison`, `--database`
- Single-record mode: returns `{mode, similarRecords, totalCount}`
- Two-record mode: client-side comparison returning `{sameType, commonTags, sizeDifference, tagSimilarity}`

## 11. `AiChat.swift` — Add missing parameters (MEDIUM #11) ✅

- Added: `--temperature` (0.0-2.0), `--engine` with all 10 DEVONthink 4.2.2 engines
- `--record` now accepts multiple values (`[String]` with `.upToNextOption` parsing)
- Sets `mode: "context"` when record context is provided
- Added `parseEngine()` with human-friendly aliases

## 12. `ConvertRecord.swift` — Add missing format types (MEDIUM #12) ✅

- Added: `bookmark`, `webarchive`/`web-archive`, `pdf`/`pdf-document`, `single-page-pdf`/`single-page-pdf-document`
- Unknown format prints warning to stderr and defaults to plain text

## 13. Build verification ✅

- `swift build` — **0 errors, 0 warnings**
- `dt --help` — all 27 subcommands visible
- `dt search --help` — shows all new parameters
- `dt ai-chat --help` — shows engine, temperature, multiple records
- `dt set-record-properties --help` — shows all exclusion flags
