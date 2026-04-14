# DEVONthink CLI Commands

Discover the live command surface with:

```bash
dt --help
dt <command> --help
```

## Global Flags

```text
--json      Output results as JSON
--help      Show help information
--version   Show the version
```

## Read-Only Commands

### is-running

Check whether DEVONthink is currently running.

```text
dt is-running
```

### current-database

Get the currently active database.

```text
dt current-database
```

Output fields: `id`, `uuid`, `name`, `path`, `filename`, `encrypted`, `readOnly`, `spotlightIndexing`, `versioning`, `revisionProof`, `comment`.

### open-databases

List all open databases.

```text
dt open-databases
```

### get-selected-records

Get the currently selected records. Returns empty array if none selected.

```text
dt get-selected-records
```

### get-record-by-identifier

Get a record by UUID, x-devonthink-item:// link, or numeric ID.

```text
dt get-record-by-identifier <identifier>
```

### get-record-properties

Get all properties of a record (extended field set).

```text
dt get-record-properties [identifier]
```

Extra fields beyond standard: `additionDate`, `flag`, `unread`, `locked`, `wordCount`, `characterCount`, `excludeFromChat`, `excludeFromClassification`, `excludeFromSearch`, `excludeFromSeeAlso`, `excludeFromTagging`, `excludeFromWikiLinking`, `plainText` (truncated 1000 chars, text types only).

### get-record-content

Get the content of a record (type-aware).

```text
dt get-record-content [identifier]
```

- RTF/RTFD → `richText`
- HTML/webarchive → `source`
- All others → `plainText`

### list-group-content

List direct children of a group.

```text
dt list-group-content [identifier]
```

### lookup-record

Lookup records by a specific field value.

```text
dt lookup-record <type> <value> [--any]
```

Types: `filename`, `path`, `url`, `tags`, `comment`, `content-hash`.
For tags, provide comma-separated values. Use `--any` to match any tag.

### search

Search for records with full parameter support.

```text
dt search <query> [options]
```

Options:

| Flag | Description |
|------|-------------|
| `--in <scope>` | Group UUID or path to restrict scope |
| `--database <name>` | Database name |
| `--group-id <id>` | Group numeric ID (requires --database) |
| `--group-path <path>` | Group path (requires --database) |
| `--use-current-group` | Search in currently selected group |
| `--comparison <mode>` | `no-case` (default), `no-umlauts`, `fuzzy`, `related` |
| `--record-type <type>` | Post-filter by type (e.g., `markdown`, `pdf`) |
| `--limit <n>` | Max results (default 50) |
| `--exclude-subgroups` | Skip subgroups |

## Write Commands

### create-record

```text
dt create-record --name <name> [--type <type>] [--content <text>] [--url <url>] [--comment <text>] [--tags <csv>] [--group <group>]
```

Types accepted by the implementation: `text`, `txt`, `markdown`, `html`, `rtf`, `bookmark`, `group`, `formatted-note`.

If `--group` is omitted, the record is created in the current database's incoming group.

### create-from-url

```text
dt create-from-url <url> [--format <format>] [--name <name>] [--group <group>] [--pdf-pagination] [--pdf-width <width>] [--readability]
```

Formats: `pdf`, `webarchive`, `markdown`, `formatted-note`.

Accepted aliases: `web-document`, `web_document`, `formatted_note`, `formatted note`.

If `--group` is omitted, the record is created in the current database's incoming group.

### update-record-content

```text
dt update-record-content <identifier> [--content <text>] [--append]
```

Type-aware: sets `source` for HTML/webarchive, `plainText` for others.
Reports which property was updated in the output.

### set-record-properties

```text
dt set-record-properties [identifier] [options]
```

Options:

| Flag | Description |
|------|-------------|
| `--name <name>` | New name |
| `--comment <text>` | New comment |
| `--url <url>` | New URL |
| `--tags <csv>` | Comma-separated tags (replaces existing) |
| `--unread` / `--read` | Mark read/unread |
| `--flag` / `--unflag` | Flag/unflag |
| `--locked` / `--unlocked` | Lock/unlock |
| `--exclude-from-chat` | Exclude from AI chat |
| `--include-in-chat` | Include in AI chat |
| `--exclude-from-classification` | Exclude from classification |
| `--include-in-classification` | Include in classification |
| `--exclude-from-search` | Exclude from search |
| `--include-in-search` | Include in search |
| `--exclude-from-see-also` | Exclude from See Also |
| `--include-in-see-also` | Include in See Also |
| `--exclude-from-tagging` | Exclude group from tagging |
| `--include-in-tagging` | Include group in tagging |
| `--exclude-from-wiki-linking` | Exclude from Wiki linking |
| `--include-in-wiki-linking` | Include in Wiki linking |

### rename-record

```text
dt rename-record <identifier> <new-name>
```

### move-record

```text
dt move-record <identifier> <destination>
```

### replicate-record

```text
dt replicate-record <identifier> <destination>
```

Source and destination must be in the same database.

### duplicate-record

```text
dt duplicate-record <identifier> <destination>
```

### delete-record

```text
dt delete-record <identifier>
```

### convert-record

```text
dt convert-record <identifier> <format> [--group <uuid>]
```

Formats: `txt`, `rtf`, `formatted-note`, `html`, `markdown`, `bookmark`, `webarchive`, `pdf`, `single-page-pdf`.

### add-tags

```text
dt add-tags [<identifier>] <tag>...
```

### remove-tags

```text
dt remove-tags [<identifier>] <tag>...
```

## AI / Classification Commands

### classify

```text
dt classify [identifier] [--comparison <data|tags>] [--tags] [--database <name>]
```

### compare

Single-record mode (find similar):

```text
dt compare [identifier] [--comparison <data|tags>] [--database <name>]
```

Two-record mode (direct comparison):

```text
dt compare <identifier> --compare-with <uuid2>
```

### ai-chat

```text
dt ai-chat <message> [--record <uuid> ...] [--engine <engine>] [--temperature <0-2>] [--model <name>] [--role <persona>] [--format <text|json|html>]
```

Engines: `chatgpt`, `claude`, `gemini`, `mistral`, `apple-intelligence`, `perplexity`, `openrouter`, `openai-compatible`, `lmstudio`, `ollama`, `remote-ollama`.

If `--engine` is omitted, the CLI uses DEVONthink's current chat engine.
If `--model` is omitted and no explicit engine is supplied, the CLI uses DEVONthink's current chat model.

### ai-summarize

```text
dt ai-summarize [identifiers...] [--format <markdown|simple|rich>] [--group <uuid>]
```

### ai-suggest-tags

```text
dt ai-suggest-tags [identifier]
```

## Standard Record Output Fields

| Field | Type | Notes |
|-------|------|-------|
| `id` | number | Scripting ID |
| `uuid` | string | Persistent UUID |
| `name` | string | Display name |
| `path` | string | Full DEVONthink path |
| `location` | string | Parent location |
| `recordType` | string | e.g., `markdown`, `group`, `pdf` |
| `kind` | string | Finder-style kind string |
| `creationDate` | string | ISO 8601 |
| `modificationDate` | string | ISO 8601 |
| `tags` | [string] | Tag array |
| `size` | number | Bytes |
| `score` | number | Search relevance (when applicable) |
| `rating` | number | 0-5 |
| `label` | number | 0-7 |
| `referenceURL` | string | x-devonthink-item:// URL |
| `comment` | string | If non-empty |
| `url` | string | External URL if set |
| `database` | string | Database name |
