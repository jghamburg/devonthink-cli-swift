# Examples

## Access Check

```bash
dt is-running
dt current-database
dt open-databases --json
```

## Inspect a Record

```bash
dt get-record-by-identifier 22511 --json
dt get-record-properties 22511 --json
dt get-record-content 22511
```

## Search and Lookup

```bash
dt search architecture --json
dt lookup-record url "x-devonthink-item://6DA8286D-BE59-4999-8DA1-89D0B71E981C" --json
dt list-group-content /
```

## Create and Edit

```bash
dt create-record --name "Meeting Notes" --type markdown --content "# Notes"
dt update-record-content <uuid> --content "Updated body"
dt set-record-properties <uuid> --comment "Reviewed" --tags "work,important"
dt rename-record <uuid> "Better Name"
```

## Tags and Organization

```bash
dt add-tags <uuid> urgent follow-up
dt remove-tags <uuid> old-tag
dt move-record <uuid> <group-uuid>
dt duplicate-record <uuid> <group-uuid>
dt convert-record <uuid> markdown --group <group-uuid>
dt delete-record <uuid>
```

## AI Workflows

```bash
dt ai-suggest-tags 22511 --json
dt ai-summarize 22511 --json
dt ai-chat "Summarize this note briefly" --record 22511 --json
dt ai-chat "Hello" --json
```

## Explicit Engine Override

```bash
dt ai-chat "Summarize this note briefly" --record 22511 --engine lmstudio --model "qwen3-coder-30b-a3b-instruct-mlx" --json
```
