# Read Commands

Use these commands to inspect DEVONthink state, resolve identifiers, and gather
context before write operations.

## App and Database State

```bash
dt is-running
dt current-database
dt open-databases
dt get-selected-records
```

Representative JSON forms:

```bash
dt is-running --json
dt open-databases --json
dt get-selected-records --json
```

## Record Inspection

```bash
dt get-record-by-identifier <identifier>
dt get-record-properties [identifier]
dt get-record-content [identifier]
dt list-group-content [identifier]
```

Notes:

- `get-record-content` is type-aware:
  - RTF/RTFD -> `richText`
  - HTML/webarchive -> `source`
  - all others -> `plainText`
- `list-group-content /` lists the root group of the current database.

## Lookup and Search

```bash
dt lookup-record <type> <value> [--any]
dt search <query> [options]
```

`lookup-record` types:

- `filename`
- `path`
- `url`
- `tags`
- `comment`
- `content-hash`

`search` options:

- `--in <scope>`
- `--database <name>`
- `--group-id <id>`
- `--group-path <path>`
- `--use-current-group`
- `--comparison <no-case|no-umlauts|fuzzy|related>`
- `--record-type <type>`
- `--limit <n>`
- `--exclude-subgroups`

## Typical Read Flow

```bash
dt is-running
dt current-database
dt search architecture --json
dt get-record-properties 22511 --json
dt get-record-content 22511
```
