# devonthink-cli-swift

Native Swift CLI for DEVONthink 4 using `ScriptingBridge.framework`.

This project provides a terminal interface to DEVONthink databases, records,
search, tagging, conversion, classification, and AI features without using JXA
or `osascript` subprocesses.

## Binaries

Both names are equivalent:

```bash
dt <command>
dt-cli <command>
```

## Requirements

- macOS 13+
- DEVONthink 4 running

## Build

```bash
swift build
make build
```

## Install

```bash
make install
```

This installs:

- `dt` — main binary
- `dt-cli` — symlink to `dt`

## Global Usage

```bash
dt [--json] <subcommand>
dt <subcommand> --help
```

- `--json` returns machine-readable output for any command
- `--help` shows exact argument and option forms

## Command Surface

```text
is-running
current-database
open-databases
get-record-by-identifier
get-record-properties
get-record-content
get-selected-records
list-group-content
lookup-record
search
create-record
create-from-url
update-record-content
set-record-properties
rename-record
move-record
replicate-record
duplicate-record
delete-record
convert-record
add-tags
remove-tags
classify
compare
ai-summarize
ai-chat
ai-suggest-tags
```

## Identifier Rules

Most record commands accept:

- `x-devonthink-item://...`
- UUID
- numeric record ID
- absolute DEVONthink path starting with `/`
- record name fallback

If an identifier is omitted on commands that support it, the CLI usually falls
back to the current DEVONthink selection.

## Common Usage Patterns

### Read-only inspection

```bash
dt is-running
dt current-database
dt open-databases --json
dt get-selected-records --json
dt get-record-properties 22511 --json
dt get-record-content 22511
```

### Search and lookup

```bash
dt search architecture --json
dt search invoice --database "Slip-Box" --limit 10 --json
dt lookup-record url "x-devonthink-item://6DA8286D-BE59-4999-8DA1-89D0B71E981C" --json
dt list-group-content /
```

### Create and mutate records

```bash
dt create-record --name "Meeting Notes" --type markdown --content "# Notes"
dt update-record-content <uuid> --content "Updated body"
dt set-record-properties <uuid> --comment "Reviewed" --tags "work,important"
dt rename-record <uuid> "Better Name"
dt add-tags <uuid> urgent follow-up
dt remove-tags <uuid> old-tag
dt delete-record <uuid>
```

### Group and conversion workflows

```bash
dt move-record <uuid> <group-uuid>
dt replicate-record <uuid> <group-uuid>
dt duplicate-record <uuid> <group-uuid>
dt convert-record <uuid> markdown --group <group-uuid>
```

### AI workflows

```bash
dt ai-suggest-tags 22511 --json
dt ai-summarize 22511 --json
dt ai-chat "Summarize this note briefly" --record 22511 --json
```

`ai-chat` defaults to DEVONthink's current chat engine and current chat model
when you do not pass `--engine` or `--model`.

## Output Conventions

- human mode: line-oriented key/value output for interactive use
- JSON mode: always wrapped in a top-level `result`

Examples:

```json
{"result": true}
{"result": {"uuid": "...", "name": "..."}}
{"result": [{"uuid": "..."}, {"uuid": "..."}]}
```

## Notes

- DEVONthink must be running for all commands except `is-running`
- There is currently no `Tests/` target in the Swift package
- The TypeScript sibling project is reference-only and not modified by this CLI
