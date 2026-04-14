# Requirements: devonthink-cli-swift

> Extracted from the TypeScript `devonthink-cli/` reference implementation on 2026-04-14.
> This document specifies functional requirements for the Swift CLI reimplementation.

---

## 1. Global Design Decisions

### 1.1 Dropped Features (deliberate)

| Feature | Reason |
|---------|--------|
| MCP layer (`tools`, `schema <tool>`) | Pure CLI; replaced by `--help` on each subcommand |
| `ai_tool_documentation` command | Replaced by `--help` |
| `check_ai_health` command | Not needed for CLI |
| Backward compat with DEVONthink < 4.1 | Target is 4.2.2; no `auditProof` fallback |
| JXA / `osascript` subprocess | Replaced by ScriptingBridge |
| JSON Schema registry | Replaced by swift-argument-parser type safety |

### 1.2 Global Conventions

| Convention | Specification |
|------------|---------------|
| Output format | Human-readable by default; `--json` flag for machine output |
| Binary names | `dt` (primary), `devonthink` (SPM alias), `dt-cli` (symlink) |
| Error reporting | Exit code 1 + stderr message; JSON mode wraps errors in `{"error":"..."}` |
| Record resolution | Many commands accept a flexible identifier string; see §2 |

---

## 2. Record Resolution (RecordResolver)

Multiple commands need to locate a record from a user-supplied identifier string.
The TS implementation uses a priority chain (from `getRecordOrSelected` helper):

| Priority | Input Pattern | Resolution Method |
|----------|---------------|-------------------|
| 1 | UUID (hex-and-hyphens) | `getRecordWithUuid(uuid)` |
| 2 | `x-devonthink-item://...` URL | Extract ID portion; try UUID lookup, URL-decode + UUID lookup, then `lookupRecordsWithURL` |
| 3 | Numeric ID | `getRecordWithId(id, in: database)` — requires database context |
| 4 | Path string (`/Inbox/...`) | `lookupRecordsWithPath(path, in: database)` |
| 5 | (no identifier given) | Fall back to current selection (`selectedRecords()`) |

### 2.1 Reference URL Handling (from `getRecordByIdentifier.ts`)

When a `x-devonthink-item://` URL is provided:
1. Strip prefix, check if remainder matches UUID regex `^[0-9A-Fa-f]{8}-...$`
2. If UUID: `getRecordWithUuid(identifier.toUpperCase())`
3. If not found or non-UUID: URL-decode identifier, try `getRecordWithUuid(decoded)`
4. Still not found: `lookupRecordsWithURL(refURL)` across all databases, verify `referenceURL()` matches

---

## 3. Command Requirements

### 3.1 Read-Only Commands

#### `is-running`
- **TS name**: `is_running`
- **Parameters**: none
- **Output**: `{isRunning: boolean}`
- **Behaviour**: Check `app.running()`; does NOT require DEVONthink to be open

#### `current-database`
- **TS name**: `current_database`
- **Parameters**: none
- **Output**: Database object with fields:
  - `id`, `uuid`, `name`, `path`, `filename`
  - `encrypted`, `readOnly`, `spotlightIndexing`, `versioning`
  - `revisionProof` (4.1+)
  - `comment` (if non-empty)
- **Behaviour**: Returns `currentDatabase` property; error if none selected

#### `open-databases`
- **TS name**: `open_databases`
- **Parameters**: none
- **Output**: `{databases: [DatabaseInfo], totalCount: number}`
- **Behaviour**: Lists all open databases with same fields as `current-database`

#### `get-selected-records`
- **TS name**: `selected_records`
- **Parameters**: none
- **Output**: `{records: [RecordInfo], totalCount: number}`
- **Record fields**: `id`, `uuid`, `name`, `path`, `location`, `recordType`, `kind`, `creationDate`, `modificationDate`, `tags`, `size`, `rating?`, `label?`, `comment?`
- **Behaviour**: Returns `selectedRecords()`; empty array if none selected

#### `get-record-by-identifier`
- **TS name**: `record_by_identifier`
- **Parameters**:
  - `uuid` (optional) — UUID of record
  - `id` (optional, number) — numeric ID (requires `databaseName`)
  - `databaseName` (optional) — database context for ID lookup
  - `referenceURL` (optional) — `x-devonthink-item://` URL
- **Output**: Full record info including `referenceURL`, `url?`, `comment?`
- **Behaviour**: Priority chain: referenceURL → uuid → id → current selection
- **Note**: Falls back to `selectedRecords()` when no identifier given

#### `get-record-properties`
- **TS name**: `record_properties`
- **Parameters**:
  - `uuid` (optional)
  - `recordId` (optional, number)
  - `recordPath` (optional) — DEVONthink location path (e.g., `/Inbox/My Document`)
  - `databaseName` (optional)
- **Output**: Extensive property set:
  - Core: `id`, `uuid`, `name`, `path`, `location`, `recordType`, `kind`
  - Dates: `creationDate`, `modificationDate`, `additionDate`
  - Metadata: `size`, `tags`, `comment`, `url`, `rating`, `label`
  - State: `flag`, `unread`, `locked` (maps to `locking` property)
  - Counts: `wordCount`, `characterCount`
  - Exclusion flags: `excludeFromChat`, `excludeFromClassification`, `excludeFromSearch`, `excludeFromSeeAlso`, `excludeFromTagging`, `excludeFromWikiLinking`
  - Content: `plainText` — **only** for `markdown`, `formatted note`, `txt` types; **truncated to 1000 chars**
- **Behaviour**: Uses full resolver chain (uuid → id → path → selection)

#### `get-record-content`
- **TS name**: `record_content`
- **Parameters**:
  - `uuid` (optional)
  - `databaseName` (optional) — verified against record's actual database
- **Output**: `{content: string}`
- **Behaviour**:
  - For `markdown`, `txt`, `formatted note`: returns `plainText`
  - For `rtf`: returns `richText`
  - For all others: returns `plainText`

#### `list-group-content`
- **TS name**: `list_group_content`
- **Parameters**:
  - `uuid` (optional) — UUID of group; defaults to database root
  - `databaseName` (optional)
- **Output**: `{records: [{uuid, name, recordType}]}`
- **Behaviour**:
  - If `uuid` is `"/"` or omitted: uses `database.root()`
  - Validates that record is a `group` or `smart group`; error otherwise
  - Returns direct children only (not recursive)

#### `lookup-record`
- **TS name**: `lookup_record`
- **Parameters**:
  - `lookupType` — **required**, one of: `filename`, `path`, `url`, `tags`, `comment`, `contentHash`
  - `value` — **required**, the search value
  - `tags` (optional, array) — for `lookupType: "tags"` 
  - `matchAnyTag` (optional, bool) — match any vs all tags
  - `databaseName` (optional)
  - `limit` (optional, default 50)
- **Output**: `{results: [RecordInfo], totalCount: number}`
- **Behaviour by lookupType**:
  - `filename`: `lookupRecordsWithFile(value, in: db)`
  - `path`: `lookupRecordsWithPath(value, in: db)`
  - `url`: For `x-devonthink-item://` URLs, extract identifier → UUID lookup; otherwise `lookupRecordsWithURL(decoded, in: db)`
  - `tags`: `lookupRecordsWithTags(tagArray, any: matchAnyTag, in: db)`; if `tags` array empty, uses `value` as single tag
  - `comment`: `lookupRecordsWithComment(value, in: db)`
  - `contentHash`: `lookupRecordsWithContentHash(value, in: db)`
- **Record output fields**: `id`, `name`, `path`, `location`, `recordType`, `kind`, `creationDate`, `modificationDate`, `tags`, `size`, `url?`, `comment?`

#### `search`
- **TS name**: `search`
- **Parameters**:
  - `query` — **required**, search query string
  - `groupUuid` (optional) — group scope by UUID
  - `groupId` (optional, number) — group scope by ID (requires `databaseName`)
  - `groupPath` (optional) — database-relative path (requires `databaseName`)
  - `databaseName` (optional)
  - `useCurrentGroup` (optional, bool) — search in currently selected group
  - `recordType` (optional) — filter: `group`, `markdown`, `PDF`, `bookmark`, `formatted note`, `txt`, `rtf`, `rtfd`, `webarchive`, `quicktime`, `picture`, `smart group`
  - `comparison` (optional) — `no case`, `no umlauts`, `fuzzy`, `related`
  - `excludeSubgroups` (optional, bool)
  - `limit` (optional, default 50)
- **Validation rules**:
  - `groupId` requires `databaseName`
  - `groupPath` requires `databaseName`
  - `useCurrentGroup` conflicts with `groupUuid`/`groupId`/`groupPath`
- **Output**: `{results: [RecordInfo with score?], totalCount: number}`
- **Behaviour**:
  - Scope resolution: `useCurrentGroup` → `currentGroup()` | group by uuid/id/path → resolved record | `databaseName` only → `database.root()` (4.1+) | neither → `null` (search all)
  - `recordType` filtering is **post-search** (filter results, not query parameter)
  - `totalCount` reflects count **after** type filtering but **before** limit

### 3.2 Write Commands

#### `create-record`
- **TS name**: `create_record`
- **Parameters**:
  - `name` — **required**
  - `type` — **required** (e.g., `markdown`, `formatted note`, `bookmark`, `group`)
  - `content` (optional) — text content
  - `url` (optional) — URL for bookmark type
  - `parentGroupUuid` (optional) — destination; defaults to `incomingGroup()`
  - `databaseName` (optional)
- **Output**: `{recordId, name, uuid}`
- **Behaviour**: Builds properties dict `{name, type, content?, URL?}` → `createRecordWith(props, in: group)`

#### `create-from-url`
- **TS name**: `create_from_url`
- **Parameters**:
  - `url` — **required**, valid URL
  - `format` — **required**: `formatted_note`, `markdown`, `pdf`, `web_document`
  - `name` (optional)
  - `parentGroupUuid` (optional) — defaults to `incomingGroup()`
  - `readability` (optional, bool)
  - `userAgent` (optional) — maps to `agent` parameter
  - `referrer` (optional)
  - `pdfOptions` (optional) — `{pagination?: bool, width?: number}` (only for `pdf` format)
  - `databaseName` (optional)
- **Output**: `{recordId, name, path, location, uuid}`
- **Behaviour**: Dispatches to format-specific methods:
  - `formatted_note` → `createFormattedNoteFrom(url, options)`
  - `markdown` → `createMarkdownFrom(url, options)`
  - `pdf` → `createPDFDocumentFrom(url, options)` (with pagination, width)
  - `web_document` → `createWebDocumentFrom(url, options)`

#### `update-record-content`
- **TS name**: `update_record_content`
- **Parameters**:
  - `uuid` (optional) — defaults to current selection
  - `content` — **required**, new content string
- **Output**: `{uuid, name, recordType, updatedProperty}`
- **Behaviour**:
  - For `HTML` or `webarchive`: sets `record.source`
  - For all others (markdown, txt, rtf, formatted note): sets `record.plainText`
  - Returns which property was updated (`"source"` or `"plainText"`)

#### `set-record-properties`
- **TS name**: `set_record_properties`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordPath`, `databaseName`
  - Properties (all optional):
    - `comment` (string) — overwrites existing
    - `flag` (bool)
    - `locked` (bool) — maps to `locking` property
    - `excludeFromChat` (bool)
    - `excludeFromClassification` (bool)
    - `excludeFromSearch` (bool)
    - `excludeFromSeeAlso` (bool)
    - `excludeFromTagging` (bool) — **only for group/smart group records**
    - `excludeFromWikiLinking` (bool)
- **Output**: `{uuid, name, recordType, updated: [string], skipped: [string]}`
- **Behaviour**:
  - Applies each property individually in try/catch
  - Reports which properties were updated vs skipped (with reason)
  - `excludeFromTagging` checks record type; skips with "not a group" if not a group

#### `rename-record`
- **TS name**: `rename_record`
- **Parameters**:
  - `uuid` (optional)
  - `newName` — **required**
  - `databaseName` (optional) — verified against record's database
- **Output**: `{uuid, oldName, newName}`
- **Behaviour**: Sets `record.name = newName`; verifies database if specified

#### `move-record`
- **TS name**: `move_record`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordName`, `recordPath`
  - `destinationGroupUuid` — **required**
  - `databaseName` (optional)
- **Output**: `{newLocation}`
- **Behaviour**:
  - Resolves source record via full chain
  - Resolves destination by UUID; validates it's a group
  - Calls `theApp.move({record: r, to: dest})`

#### `replicate-record`
- **TS name**: `replicate_record`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordPath`
  - `destinationGroupUuid` — **required**
  - `databaseName` (optional)
- **Output**: `{replicatedRecord: {id, uuid, name, path, location, recordType}}`
- **Behaviour**:
  - Validates destination is a group
  - **Validates source and destination are in same database** (required for replication)
  - Calls `theApp.replicate({record: r, to: dest})`

#### `duplicate-record`
- **TS name**: `duplicate_record`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordPath`
  - `destinationGroupUuid` — **required**
  - `databaseName` (optional)
- **Output**: `{duplicatedRecord: {id, uuid, name, path, location, recordType, databaseName}}`
- **Behaviour**:
  - Validates destination is a group
  - No same-database requirement (unlike replicate)
  - Calls `theApp.duplicate({record: r, to: dest})`

#### `delete-record`
- **TS name**: `delete_record`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordPath`
  - `databaseName` (optional)
- **Output**: `{success: boolean}`
- **Behaviour**: Calls `theApp.delete({record: r})`

#### `convert-record`
- **TS name**: `convert_record`
- **Parameters**:
  - Record identifiers: `uuid`, `recordId`, `recordPath`
  - `format` — **required**: `bookmark`, `simple`, `rich`, `note`, `markdown`, `HTML`, `webarchive`, `PDF document`, `single page PDF document`, `PDF without annotations`, `PDF with annotations burnt in`
  - `destinationGroupUuid` (optional)
  - `databaseName` (optional)
- **Output**: `{convertedRecord: {id, uuid, name, path, location, recordType, format}}`
- **Behaviour**:
  - Validates destination is a group (if provided)
  - Calls `theApp.convert({record: r, to: format, in: destGroup?})`

#### `add-tags`
- **TS name**: `add_tags`
- **Parameters**:
  - `uuid` (optional) — defaults to current selection
  - `tags` — **required**, array of strings
- **Output**: `{success: boolean}`
- **Behaviour**: Gets existing tags, concatenates new tags: `record.tags = existing.concat(newTags)`
- **Note**: Does NOT deduplicate; appends blindly

#### `remove-tags`
- **TS name**: `remove_tags`
- **Parameters**:
  - `uuid` (optional)
  - `tags` — **required**, array of strings
  - `databaseName` (optional) — verified against record's database
- **Output**: `{success: boolean}`
- **Behaviour**: Filters existing tags: `record.tags = existing.filter(t => !toRemove.has(t))`

### 3.3 AI / Classification Commands

#### `classify`
- **TS name**: `classify`
- **Parameters**:
  - `recordUuid` (optional) — defaults to current selection
  - `databaseName` (optional) — scope
  - `comparison` (optional) — `data comparison` or `tags comparison`
  - `tags` (optional, bool) — propose tags instead of groups
- **Output**: `{proposals: [{name, type, location?, score?}], totalCount}`
- **Behaviour**: `theApp.classify({record: r, in: db?, comparison?, tags?})`

#### `compare`
- **TS name**: `compare`
- **Parameters**:
  - `recordUuid` (optional) — primary record
  - `compareWithUuid` (optional) — second record for direct comparison
  - `databaseName` (optional)
  - `comparison` (optional) — `data comparison` or `tags comparison`
- **Output** (two modes):
  - **Single-record mode** (no `compareWithUuid`): `{mode: "single_record", similarRecords: [RecordInfo with score?], totalCount}`
  - **Two-record mode**: `{mode: "two_record", comparison: {record1, record2, similarities: {sameType, commonTags, sizeDifference, tagSimilarity}}}`
- **Behaviour**:
  - Single mode: `theApp.compare({record: r, to: db?, comparison?})` — returns similar records
  - Two-record mode: Fetches properties of both, computes similarities client-side:
    - `sameType`: `record1.recordType === record2.recordType`
    - `commonTags`: intersection of tag arrays
    - `sizeDifference`: `abs(size1 - size2)`
    - `tagSimilarity`: `commonTags.length / max(tags1.length, tags2.length, 1)`

#### `ai-chat` (maps to TS `ask_ai_about_documents`)
- **TS name**: `ask_ai_about_documents`
- **Parameters**:
  - `documentUuids` — **required**, array of UUIDs (min 1)
  - `question` — **required** (1-10000 chars)
  - `temperature` (optional, 0-2, default 0.7)
  - `model` (optional)
  - `engine` (optional) — default `ChatGPT`; values: `ChatGPT`, `Claude`, `Gemini`, `Mistral AI`, `GPT4All`, `LM Studio`, `Ollama`
- **Output**: `{response, recordsAnalyzed, records: [{uuid, name, type}], warnings?}`
- **Behaviour**:
  - Resolves all UUIDs to records; collects errors for unfound ones
  - Calls `getChatResponseForMessage(question, {record: [records], temperature, engine, mode: "context", model?})`
  - `mode: "context"` is required when passing records

#### `ai-summarize` (maps to TS `create_summary_document`)
- **TS name**: `create_summary_document`
- **Parameters**:
  - `documentUuids` — **required**, array of UUIDs (min 1)
  - `summaryType` (optional, default `markdown`) — `markdown`, `rich`, `sheet`, `simple`
  - `summaryStyle` (optional) — `text summary`, `key points summary`, `list summary`, `table summary`, `custom summary` — **NOTE: documented as non-functional in TS**
  - `parentGroupUuid` (optional) — destination; defaults to `incomingGroup()`
  - `customTitle` (optional) — rename summary after creation
- **Output**: `{summaryUuid, summaryName, summaryLocation, summaryType, recordsAnalyzed, records, warnings?}`
- **Behaviour**: `theApp.summarizeContentsOf({records: [objects], to: type, in: group, as: style?})`

#### `ai-suggest-tags`
- **TS name**: (no direct equivalent — wraps classify with `tags: true`)
- **Parameters**:
  - `uuid` (optional) — record to get tag suggestions for
- **Output**: Tag suggestion proposals
- **Behaviour**: Calls classify with `tags: true` parameter

---

## 4. Database Info Fields

All commands that return database information use this field set:

| Field | Type | Notes |
|-------|------|-------|
| `id` | number | Numeric ID |
| `uuid` | string | Database UUID |
| `name` | string | Display name |
| `path` | string | Filesystem path |
| `filename` | string | File name |
| `encrypted` | boolean | |
| `readOnly` | boolean | |
| `spotlightIndexing` | boolean | |
| `versioning` | boolean | |
| `revisionProof` | boolean | 4.1+ only |
| `comment` | string? | If non-empty |

---

## 5. Record Info Fields

### 5.1 Standard Record Info (used by search, lookup, selected-records)

| Field | Type | Notes |
|-------|------|-------|
| `id` | number | |
| `uuid` | string | |
| `name` | string | |
| `path` | string | Full DEVONthink path |
| `location` | string | Parent location |
| `recordType` | string | e.g., `markdown`, `group`, `PDF` |
| `kind` | string | Finder-style kind string |
| `creationDate` | string? | ISO date string |
| `modificationDate` | string? | |
| `tags` | [string] | |
| `size` | number | Bytes |
| `score` | number? | Search relevance (search only) |
| `rating` | number? | 0-5 (selected-records only) |
| `label` | number? | 0-7 (selected-records only) |
| `comment` | string? | If non-empty |
| `url` | string? | External URL if set |

### 5.2 Full Properties (get-record-properties)

Extends standard fields with:
- `additionDate` — when record was added to database
- `flag` (boolean)
- `unread` (boolean)
- `locked` (boolean) — maps to `locking` property
- `wordCount`, `characterCount`
- All `excludeFrom*` flags
- `plainText` — truncated to 1000 chars, only for text-based types

---

## 6. AI Engine Mapping

### TS constants (from `constants.ts`):
```
ChatGPT, Claude, Gemini, Mistral AI, GPT4All, LM Studio, Ollama
```

### DEVONthink 4.2.2 ScriptingBridge enum values:
```
AppleIntelligence, ChatGPT, Claude, Gemini, Mistral, Perplexity,
OpenRouter, OpenAICompatible, LMStudio, Ollama
```

### Mapping notes:
- `Mistral AI` (TS) → `Mistral` (ScriptingBridge enum `DEVONthinkChatEngineMistral`)
- `GPT4All` (TS) — **not present** in 4.2.2 ScriptingBridge; dropped
- `LM Studio` (TS) → `LMStudio` (ScriptingBridge)
- New in 4.2.2: `AppleIntelligence`, `Perplexity`, `OpenRouter`, `OpenAICompatible`

---

## 7. Non-Functional Requirements

1. **No osascript**: All DEVONthink communication via `ScriptingBridge.framework`
2. **Error handling**: Every command must catch ScriptingBridge exceptions and convert to user-friendly messages
3. **JSON output**: Every command supports `--json`; default is human-readable
4. **No MCP layer**: No JSON schema registry, no `run()` dispatch table
5. **No stdin input**: All parameters via command-line flags/arguments
6. **Exit codes**: 0 for success, 1 for errors
7. **DEVONthink must be running** for all commands except `is-running`
