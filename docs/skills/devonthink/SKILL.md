---
name: devonthink
description: Operate the DEVONthink CLI for databases, records, search, tags, and AI workflows. Use when requests mention the `devonthink`, `dt`, or `dt-cli` commands, or the npm package `devonthink`, especially for command construction, schema inspection, JSON output, and record/database operations.
---

# DEVONthink CLI (Swift)

## Overview

Use this skill to run the DEVONthink CLI safely and produce exact commands for the
implemented command surface. The Swift CLI communicates with DEVONthink 4 via
native macOS ScriptingBridge — no JXA or osascript.

Prefer read-only commands first when verifying identifiers or database context.
Use `--json` output when the result will be piped to other tools or parsed by code.

Read `references/commands.md` for the supported command surface.
Read `references/examples.md` for concrete examples.

## Binary Names

All three names are equivalent:

```bash
dt <command>         # primary (short)
devonthink <command> # full name
dt-cli <command>     # symlink alias
```

## Exact Command Surface

Use these exact kebab-case command names. Do not invent `get_*` or underscore variants.

```text
is-running
current-database
open-databases
get-selected-records
get-record-by-identifier <identifier>
get-record-properties [identifier]
get-record-content [identifier]
list-group-content [identifier]
lookup-record <type> <value> [--any]
search <query> [options]
create-record --name <name> [--type <type>] [--content <text>] [--group <group>]
create-from-url <url> [--format <format>] [--group <group>]
update-record-content <identifier> [--content <text>] [--append]
set-record-properties [identifier] [options]
rename-record <identifier> <new-name>
move-record <identifier> <destination>
replicate-record <identifier> <destination>
duplicate-record <identifier> <destination>
delete-record <identifier> [--from <group>]
convert-record <identifier> <to-format> [--group <group>]
add-tags [identifier] <tag>...
remove-tags [identifier] <tag>...
classify [identifier] [--comparison <data|tags>] [--tags] [--database <name>]
compare [identifier] [--compare-with <identifier>] [--comparison <data|tags>] [--database <name>]
ai-summarize <identifiers>... [--format <markdown|simple|rich>] [--group <group>]
ai-chat <message> [--record <identifier> ...] [--engine <engine>] [--model <model>]
ai-suggest-tags [identifier]
```

## Runbook

1. Confirm DEVONthink is running with `dt is-running`.
2. Confirm the active or target database with `dt current-database` or `dt open-databases`.
3. Resolve record UUIDs with read-only commands before write operations.
4. Prefer `--json` for automation and downstream parsing.
5. Before mutating records, verify the target with `get-record-properties`, `get-record-by-identifier`, `search`, or `lookup-record`.

## Record Identifiers

Most commands accept a flexible identifier string. The resolver tries these in order:

1. **x-devonthink-item:// URL** — strips prefix, extracts UUID
2. **UUID** — 36-char hex-and-hyphens format
3. **Numeric ID** — integer scripting ID
4. **Path** — starts with `/`
5. **Name** — fallback search by name
6. **(empty)** — falls back to current selection

## Output Strategy

Use default human-readable output for interactive use.
Use `--json` for automation and downstream parsing.

```bash
dt search invoice --json
dt get-record-properties <uuid> --json
```

## Common Tasks

```bash
# verify DEVONthink is running
dt is-running

# list open databases
dt open-databases

# inspect the current database
dt current-database

# search for records
dt search invoice --database "Test"

# search with filtering
dt search "kind:pdf" --record-type pdf --limit 10 --json

# get a record by UUID
dt get-record-properties <uuid>

# read record content (type-aware: plainText, richText, or source)
dt get-record-content <uuid>

# create a note
dt create-record --name "Meeting Notes" --type markdown --content "# Notes"

# update content
dt update-record-content <uuid> --content "Updated body"

# rename a record
dt rename-record <uuid> "Renamed note"

# add tags
dt add-tags <uuid> work important

# remove tags
dt remove-tags <uuid> old-tag

# set properties including exclusion flags
dt set-record-properties <uuid> --flag --exclude-from-search

# classify a record
dt classify <uuid> --comparison tags --database "Research"

# compare two records
dt compare <uuid1> --compare-with <uuid2>

# AI chat with context
dt ai-chat "Summarize this document" --record <uuid>

# AI summarize
dt ai-summarize <uuid1> <uuid2> --format markdown
```

## Safety Checks

Before write operations:

1. Confirm the target database with `current-database` or `open-databases`.
2. Confirm the target record with `get-record-properties`, `get-record-by-identifier`, `search`, or `lookup-record`.
3. Confirm the destination group before `move-record`, `duplicate-record`, `replicate-record`, or `convert-record`.
4. Prefer UUIDs over names when mutating records.

## AI Engines

The `ai-chat` command supports these engines via `--engine`:

| Engine | Flag value |
|--------|-----------|
| ChatGPT | `chatgpt` |
| Claude | `claude` |
| Gemini | `gemini` |
| Mistral | `mistral` |
| Apple Intelligence | `apple-intelligence` |
| Perplexity | `perplexity` |
| OpenRouter | `openrouter` |
| OpenAI-compatible | `openai-compatible` |
| LM Studio | `lmstudio` |
| Ollama | `ollama` |
| Remote Ollama | `remote-ollama` |

If `--engine` is omitted, the CLI uses DEVONthink's current chat engine.
If `--model` is omitted and no explicit engine is supplied, the CLI uses
DEVONthink's current chat model.

## Dropped Commands (vs TypeScript version)

These commands from the TypeScript/MCP version are not present:

- `tools` / `schema <tool>` — replaced by `--help` on each subcommand
- `ai_tool_documentation` — replaced by `--help`
- `check_ai_health` — not needed for native ScriptingBridge

## Notes

- `dt`, `devonthink`, and `dt-cli` are equivalent and map to the same implementation.
- Use `dt <command> --help` for exact parameter names and types.
- DEVONthink must be running for all commands except `is-running`.
- Built with ScriptingBridge — no JXA or osascript subprocess overhead.
