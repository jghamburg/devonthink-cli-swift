---
name: dt-cli
description: Use when requests mention `dt`, `devonthink`, or `dt-cli`, especially for DEVONthink CLI command construction, record lookup, JSON output, and AI workflows.
---

# dt-cli

## Overview

Use this skill when a request references `dt`, `devonthink`, or `dt-cli`.
The CLI in this repo is the native Swift implementation that talks to
DEVONthink 4 via ScriptingBridge.

Prefer read-only commands first to verify database context, record identifiers,
and destinations before mutation.

## Binaries

All three names are equivalent:

```bash
dt <command>
devonthink <command>
dt-cli <command>
```

## Workflow

1. Confirm DEVONthink is running with `dt is-running`.
2. Confirm the active database with `dt current-database` or list all open
   databases with `dt open-databases`.
3. Resolve target records with `get-record-by-identifier`,
   `get-record-properties`, `search`, `lookup-record`, or
   `get-selected-records` before mutating anything.
4. Prefer UUIDs over names for write operations.
5. Use `--json` whenever output will be piped or parsed.
6. For `ai-chat`, omit `--engine` and `--model` if you want the CLI to use
   DEVONthink's current chat engine/model.

## References

- `references/read-commands.md` — databases, records, lookup, search
- `references/write-commands.md` — create, update, move, convert, delete
- `references/ai-commands.md` — classify, compare, summarize, chat, tag suggestions
- `references/usage-patterns.md` — identifiers, JSON output, safe workflows
- `references/examples.md` — concrete command examples

## Notes

- `dt <command> --help` is the authoritative command surface.
- `--json` is available globally on the root command.
- DEVONthink must be running for all commands except `is-running`.
