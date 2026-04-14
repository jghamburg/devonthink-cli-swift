# Usage Patterns

## Identifier Resolution

Most record commands accept these identifier forms:

1. `x-devonthink-item://...`
2. UUID
3. numeric record ID
4. DEVONthink path beginning with `/`
5. record name fallback
6. omitted identifier -> current selection where supported

Prefer UUIDs for all mutating commands.

## JSON Output

Use `--json` whenever output is being piped or parsed.

Typical result shapes:

```json
{"result": true}
{"result": {"uuid": "...", "name": "..."}}
{"result": [{"uuid": "..."}, {"uuid": "..."}]}
```

Errors are printed on stderr.

## Safe Mutation Workflow

Before mutation:

1. `dt is-running`
2. `dt current-database` or `dt open-databases`
3. resolve the target with `get-record-properties`, `search`, or `lookup-record`
4. verify destination groups with `list-group-content` or explicit UUIDs
5. run the write command

## Destination Defaults

- `create-record` -> current database incoming group if `--group` is omitted
- `create-from-url` -> current database incoming group if `--group` is omitted
- `list-group-content /` -> root group of the current database
- `ai-chat` -> current DEVONthink chat engine/model if not explicitly overridden

## Record-Context AI Pattern

For grounded chat about a note:

```bash
dt ai-chat "Summarize this note briefly" --record <uuid>
```

For AI summarization that creates a summary note:

```bash
dt ai-summarize <uuid> --json
```
