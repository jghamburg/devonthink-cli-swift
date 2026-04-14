# devonthink-cli-swift — Project Context

## Goal

Build a full Swift-based CLI reimplementation of the TypeScript `devonthink-cli` tool, replacing the `osascript`/JXA subprocess approach with native macOS ScriptingBridge. The project lives at `devonthink-cli-swift/` as a sibling to the existing `devonthink-cli/`. Agent skills are maintained under `docs/skills/`.

---

## Requirements

- **No backward compatibility** with DEVONthink versions before 4.1. DEVONthink 4.2.2 is installed at `/Applications/DEVONthink.app`
- **Drop MCP layer entirely** — pure CLI using `swift-argument-parser`, no JSON schema registry, no `run()` dispatch, no `tools` or `schema <tool>` commands
- **Drop `ai_tool_documentation` command** — replaced by `--help` on individual commands
- **Use `ScriptingBridge.framework`** for all DEVONthink communication — no `osascript` subprocess
- **Base directory**: `/Users/jgellien/git/projects/ai-explorer/devonthink-cli-swift/`
- **Agent skill location**: `devonthink-cli-swift/docs/skills/devonthink/` and `docs/skills/dt-cli/`
- **Binary aliases**: `dt` (SPM executable target) and `dt-cli` (symlink → `~/.local/bin/dt`)
- **Global `--json` flag** on every command for machine-readable output
- The existing TypeScript project at `devonthink-cli/` is **read-only reference** — do not modify it
- `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` has been run — `sdef` and `sdp` tools are working
- The ScriptingBridge header was generated with:
  `sdef "/Applications/DEVONthink.app" | sdp -fh --basename DEVONthink -o Sources/DevonthinkCore/Bridge/`

---

## Confirmed Discoveries (all verified by compiler or test compilation)

### Application identity
- DEVONthink's bundle identifier is `com.devon-technologies.think`
- Generated `DEVONthink.h` header is ~70 KB at `Sources/DevonthinkCore/Bridge/DEVONthink.h`

### Enum usage (C typedef enums, NOT Swift enums)
The generated header uses plain C typedef enums, not `NS_ENUM`. They are NOT imported as Swift enums and must be used as **bare constants without a dot prefix**:
- ✅ `DEVONthinkSearchComparisonNoCase`  ❌ `.DEVONthinkSearchComparisonNoCase`
- ✅ `DEVONthinkConvertTypeSimple`       ❌ `.DEVONthinkConvertTypeSimple`
- ✅ `DEVONthinkComparisonTypeDataComparison` ❌ `.DEVONthinkComparisonTypeDataComparison`
- ✅ `DEVONthinkSummaryTypeMarkdown`     ❌ `.DEVONthinkSummaryTypeMarkdown`
- ✅ `DEVONthinkSummaryStyleTextSummary` ❌ `.DEVONthinkSummaryStyleTextSummary`
- ✅ `DEVONthinkChatEngineChatGPT`       ❌ `.DEVONthinkChatEngineChatGPT`
- ✅ `DEVONthinkChatUsageAuto`           ❌ `.DEVONthinkChatUsageAuto`

### SBElementArray methods — must be called as functions
`databases`, `selectedRecords`, `children` are ObjC no-argument methods imported as Swift functions:
- ✅ `app.databases()` as? [DEVONthinkDatabase]
- ✅ `app.selectedRecords()` as? [DEVONthinkRecord]
- ✅ `group.children()` as? [DEVONthinkRecord]
Using them as properties (without `()`) silently fails — the cast from `() -> SBElementArray?` to an array type always returns nil.

### Properties: no optional chaining on app methods
All ScriptingBridge app methods are non-optional — do NOT use `?`:
- ✅ `app.search(...)` ❌ `app.search?(...)`

### URL property renamed to url (lowercase)
- ✅ `record.url`  ❌ `record.URL`
- ✅ `record.url = u`  ❌ `record.URL = u`

### Record property setters — direct assignment, not methods
```swift
record.name = n
record.comment = c
record.url = u
record.tags = tagList  // [String]
record.unread = true
record.flag = true
record.plainText = content
```

### `flag` not `flagged`
The property is `flag` (verified from header: `@property BOOL flag; // The flag of a record.`)

### `SpotlightIndexing` → `spotlightIndexing` in Swift
The ObjC header declares `@property BOOL SpotlightIndexing;` but Swift 3 automatically renames it to `spotlightIndexing` (lowercase). Using `SpotlightIndexing` in Swift code produces a compile error: "'SpotlightIndexing' has been renamed to 'spotlightIndexing'".

### currentDatabase / currentGroup — properties, NOT methods
```swift
app.currentDatabase  // no ()
app.currentGroup     // no ()
```

### Swift method renames — "With" pattern
Swift renames ObjC methods by moving `With` to a labeled argument. Confirmed working:
| ObjC | Swift |
|------|-------|
| `lookupRecordsWithFile:in:` | `lookupRecords(withFile:in:)` |
| `lookupRecordsWithPath:in:` | `lookupRecords(withPath:in:)` |
| `lookupRecordsWithURL:in:` | `lookupRecords(withURL:in:)` |
| `lookupRecordsWithTags:any:in:` | `lookupRecords(withTags:any:in:)` |
| `lookupRecordsWithComment:in:` | `lookupRecords(withComment:in:)` |
| `lookupRecordsWithContentHash:in:` | `lookupRecords(withContentHash:in:)` |
| `createRecordWith:in:` | `createRecord(with:in:)` |
| `createPDFDocumentFrom:agent:in:name:pagination:readability:referrer:width:` | `createPDFDocument(from:agent:in:name:pagination:readability:referrer:width:)` |
| `createWebDocumentFrom:agent:in:name:readability:referrer:` | `createWebDocument(from:agent:in:name:readability:referrer:)` |
| `createMarkdownFrom:agent:in:name:readability:referrer:` | `createMarkdown(from:agent:in:name:readability:referrer:)` |
| `createFormattedNoteFrom:agent:in:name:readability:referrer:source:` | `createFormattedNote(from:agent:in:name:readability:referrer:source:)` |
| `getChatResponseForMessage:record:mode:image:URL:model:role:engine:temperature:thinking:toolCalls:usage:as:` | `getChatResponse(forMessage:record:mode:image:url:model:role:engine:temperature:thinking:toolCalls:usage:as:)` *(note: `URL:` → `url:` lowercase)* |

### Swift method renames — EXCEPTION: `getRecord*` methods NOT renamed
Despite the general "With" rename pattern, `getRecordWithId:in:` and `getRecordWithUuid:in:` keep their ObjC names in Swift (verified by test compilation):
- ✅ `app.getRecordWithId(numericId, in: nil as AnyObject?)`
- ✅ `app.getRecordWithUuid(uuid, in: nil as AnyObject?)`
- ❌ `app.getRecord(withId:in:)` — does not exist
- ❌ `app.getRecord(withUuid:in:)` — does not exist

The `nil as AnyObject?` cast is required for the `in:` parameter to avoid "nil requires contextual type" errors.

### DEVONthinkDataType valid enum values
```
DEVONthinkDataTypeGroup, DEVONthinkDataTypeSmartGroup, DEVONthinkDataTypeFeed,
DEVONthinkDataTypeBookmark, DEVONthinkDataTypeFormattedNote, DEVONthinkDataTypeHTML,
DEVONthinkDataTypeWebarchive, DEVONthinkDataTypeMarkdown, DEVONthinkDataTypeTxt,
DEVONthinkDataTypeRTF, DEVONthinkDataTypeRTFD, DEVONthinkDataTypePicture,
DEVONthinkDataTypeMultimedia, DEVONthinkDataTypePDFDocument, DEVONthinkDataTypeSheet,
DEVONthinkDataTypeXML, DEVONthinkDataTypeUnknown
```
**Invalid/nonexistent**: `DEVONthinkDataTypeGIF`, `DEVONthinkDataTypeJPEG`, `DEVONthinkDataTypePNG` (use `Picture`), `DEVONthinkDataTypeMovieFile`, `DEVONthinkDataTypeMusicFile` (use `Multimedia`), `DEVONthinkDataTypePDF` (use `PDFDocument`), `DEVONthinkDataTypeRichText` (use `RTF`/`RTFD`), `DEVONthinkDataTypeText` (use `Txt`), `DEVONthinkDataTypeWebArchive` (wrong case, use `Webarchive`), `DEVONthinkDataTypeScript`

### DEVONthinkConvertType valid enum values
```
DEVONthinkConvertTypeBookmark, DEVONthinkConvertTypeSimple (plain text),
DEVONthinkConvertTypeRich (RTF), DEVONthinkConvertTypeNote (formatted note),
DEVONthinkConvertTypeMarkdown, DEVONthinkConvertTypeHTML,
DEVONthinkConvertTypeWebarchive, DEVONthinkConvertTypePDFDocument,
DEVONthinkConvertTypeSinglePagePDFDocument
```

### DEVONthinkSummaryType values
```
DEVONthinkSummaryTypeMarkdown, DEVONthinkSummaryTypeSimple,
DEVONthinkSummaryTypeRich, DEVONthinkSummaryTypeSheet
```

### DEVONthinkSummaryStyle values
```
DEVONthinkSummaryStyleListSummary, DEVONthinkSummaryStyleKeyPointsSummary,
DEVONthinkSummaryStyleTableSummary, DEVONthinkSummaryStyleTextSummary,
DEVONthinkSummaryStyleCustomSummary
```

### DEVONthinkComparisonType (classify/compare)
```
DEVONthinkComparisonTypeDataComparison, DEVONthinkComparisonTypeTagsComparison
```

### DEVONthinkChatEngine values
```
DEVONthinkChatEngineAppleIntelligence, DEVONthinkChatEngineChatGPT,
DEVONthinkChatEngineClaude, DEVONthinkChatEngineGemini, DEVONthinkChatEngineMistral,
DEVONthinkChatEnginePerplexity, DEVONthinkChatEngineOpenRouter,
DEVONthinkChatEngineOpenAICompatible, DEVONthinkChatEngineLMStudio, DEVONthinkChatEngineOllama
```

### DEVONthinkChatUsage values
```
DEVONthinkChatUsageCheapest, DEVONthinkChatUsageAuto, DEVONthinkChatUsageBest
```

### DEVONthinkSearchComparison values
```
DEVONthinkSearchComparisonNoCase, DEVONthinkSearchComparisonNoUmlauts,
DEVONthinkSearchComparisonFuzzy, DEVONthinkSearchComparisonRelated
```

### Other class notes
- `DEVONthinkSelectedRecord` is a subclass of `DEVONthinkRecord`

---

## Project Structure

```
devonthink-cli-swift/
├── Package.swift
├── Makefile                            ← build, install, uninstall
├── CONTEXT.md                          ← this file
├── LICENSE                             ← MIT 2026 jghamburg
├── AGENTS.md                           ← AI agent guidance
├── README.md                           ← install, usage, CI badge, attribution
├── .releaserc.json                     ← semantic-release config
├── package.json                        ← semantic-release devDeps
├── package-lock.json                   ← lockfile (committed)
├── .github/
│   └── workflows/
│       ├── ci.yml                      ← swift build on push + PR (macos-15)
│       └── release.yml                 ← semantic-release on main push
├── docs/
│   ├── 2026-04-14-requirements.md          ← full requirements extracted from TS
│   ├── 2026-04-14-gap-fix-plan.md          ← cross-check gap fixes (all done)
│   ├── 2026-04-14-runtime-optimization-plan.md  ← benchmark history + remaining items
│   └── skills/
│       ├── devonthink/                     ← legacy skill (original naming)
│       │   ├── SKILL.md
│       │   └── references/
│       │       ├── commands.md
│       │       └── examples.md
│       └── dt-cli/                         ← current skill
│           ├── SKILL.md
│           └── references/
│               ├── read-commands.md
│               ├── write-commands.md
│               ├── ai-commands.md
│               ├── usage-patterns.md
│               └── examples.md
└── Sources/
    ├── dt/
    │   └── main.swift                  ← entry point for `dt` binary
    └── DevonthinkCore/
        ├── Bridge/
        │   ├── DEVONthink.h            ← generated, do not modify
        │   └── DevonthinkCore-Bridging-Header.h
        ├── Version.swift               ← managed by semantic-release; do not edit manually
        ├── CliError.swift
        ├── Output/
        │   └── Output.swift
        ├── Lookup/
        │   └── RecordResolver.swift
        └── Commands/
            ├── DTCommand.swift
            ├── IsRunning.swift
            ├── CurrentDatabase.swift
            ├── OpenDatabases.swift
            ├── GetRecordByIdentifier.swift
            ├── GetRecordProperties.swift
            ├── GetRecordContent.swift
            ├── GetSelectedRecords.swift
            ├── ListGroupContent.swift
            ├── LookupRecord.swift
            ├── Search.swift
            ├── CreateRecord.swift
            ├── CreateFromUrl.swift
            ├── UpdateRecordContent.swift
            ├── SetRecordProperties.swift
            ├── RenameRecord.swift
            ├── MoveRecord.swift
            ├── ReplicateRecord.swift
            ├── DuplicateRecord.swift
            ├── DeleteRecord.swift
            ├── ConvertRecord.swift
            ├── AddTags.swift
            ├── RemoveTags.swift
            ├── Classify.swift
            ├── Compare.swift
            ├── AiSummarize.swift
            ├── AiChat.swift
            └── AiSuggestTags.swift
```

---

## Progress Status

| Phase | Description | Status |
|-------|-------------|--------|
| 0 | Project scaffold (Package.swift, main.swift files) | ✅ Done |
| 1 | ScriptingBridge header generated + bridging header | ✅ Done |
| 2 | CliError.swift, Output.swift, RecordResolver.swift | ✅ Done |
| 3–8 | All 27 command files + DTCommand.swift | ✅ Done |
| 9 | Build passing (compiler errors fixed) | ✅ Done |
| 9b | Cross-check gap fixes (all 12 gaps) | ✅ Done |
| 10 | Agent skill docs (SKILL.md, references) | ✅ Done |
| 11 | `dt-cli` symlink via Makefile install | ✅ Done |
| 12 | Runtime optimization: Phase 1+3 (slim formatter, ISO8601 cache, isUUID) | ✅ Done |
| 13 | Runtime optimization: Phase 2 (pALL batch fetch, dual-key, FourCC fixes) | ✅ Done |
| 14 | Runtime optimization: Phase 4 (`record.id()` from batch, `get-record-properties` batch reuse) | ✅ Done |
| 15 | Drop `devonthink` binary — only `dt` + `dt-cli` symlink | ✅ Done |
| 16 | Public release setup: MIT license, Version.swift, CI/CD workflows, semantic-release | ⚠️ Partial |

### Performance summary
`dt search` vs Node.js/osascript reference: **5.09× faster** (180ms vs 917ms).  
See `docs/2026-04-14-runtime-optimization-plan.md` for full benchmark history.

### Phase 16 completion details
All release setup files created and committed. **Push to GitHub is blocked** — SSH operations
on `github.com` use the `joerggellien4711` key, not `jghamburg`. HTTPS push requires the
`workflow` scope token, but the tool call to embed the token in the remote URL was rejected.

**To unblock (resume next session):**
1. Confirm `jghamburg` token has `workflow` scope: `gh auth status`
   - If not: `gh auth refresh -h github.com -s workflow`
2. Push via HTTPS:
   ```sh
   TOKEN=$(gh auth token -h github.com)
   git -C /path/to/devonthink-cli-swift \
     remote set-url origin "https://jghamburg:${TOKEN}@github.com/jghamburg/devonthink-cli-swift.git"
   git push -u origin main
   git remote set-url origin git@github.com:jghamburg/devonthink-cli-swift.git
   ```
   Or configure an SSH key for `jghamburg` and push via SSH.
3. After push: verify CI workflow runs at `github.com/jghamburg/devonthink-cli-swift/actions`
4. Confirm no release was auto-triggered (correct — first push is all `chore:` commits)
5. Trigger `v1.0.0`: `git commit --allow-empty -m "feat: native Swift CLI for DEVONthink 4 via ScriptingBridge"`

---


All gaps from the cross-check of Swift implementation vs TypeScript requirements have been fixed.
See `docs/2026-04-14-gap-fix-plan.md` for the full list of 12 fixes applied.
Build: 0 errors, 0 warnings. All 27 subcommands operational.

---

## Reference

- TypeScript reference project (read-only): `/Users/jgellien/git/projects/ai-explorer/devonthink-cli/`
- DEVONthink app: `/Applications/DEVONthink.app`
- Bundle ID: `com.devon-technologies.think`
