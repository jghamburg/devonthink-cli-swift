# DEVONthink CLI Examples

## Basic Access Check

```bash
# is DEVONthink running?
dt is-running
dt is-running --json
# → {"result": true}

# what database is active?
dt current-database
dt current-database --json
```

## List Databases and Selected Records

```bash
dt open-databases
dt open-databases --json

dt get-selected-records
dt get-selected-records --json
```

## Search

```bash
# simple search
dt search invoice

# search in a specific database
dt search invoice --database "Research"

# search with comparison mode
dt search invoice --comparison fuzzy --json

# search with type filter and limit
dt search "kind:pdf" --record-type pdf --limit 10 --json

# search in current group only
dt search "status:draft" --use-current-group

# search in a specific group by path (requires --database)
dt search meeting --group-path "/Projects/2026" --database "Work"

# search excluding subgroups
dt search "tag:inbox" --in <group-uuid> --exclude-subgroups
```

## Inspect a Record

```bash
# standard record info
dt get-record-by-identifier <uuid>
dt get-record-by-identifier "x-devonthink-item://ABC123-DEF456"

# full properties (includes flags, counts, exclusions)
dt get-record-properties <uuid>
dt get-record-properties <uuid> --json

# read content (type-aware: plainText, richText, or source)
dt get-record-content <uuid>
```

## Lookup Records

```bash
# by filename
dt lookup-record filename "report.pdf"

# by path
dt lookup-record path "/Inbox/My Document"

# by tags (match all)
dt lookup-record tags "work,important"

# by tags (match any)
dt lookup-record tags "work,important" --any

# by URL (including x-devonthink-item:// links)
dt lookup-record url "https://example.com"

# by comment
dt lookup-record comment "review needed"

# by content hash
dt lookup-record content-hash "abc123def456"
```

## List Group Contents

```bash
dt list-group-content /
dt list-group-content <group-uuid>
dt list-group-content <group-uuid> --json
```

## Create Records

```bash
# create a markdown note
dt create-record --name "Meeting Notes" --type markdown --content "# Meeting Notes\n\nAction items..."

# create a bookmark
dt create-record --name "Example Site" --type bookmark --url "https://example.com"

# create a group
dt create-record --name "Project Files" --type group

# create in a specific group
dt create-record --name "Draft" --type markdown --group <group-uuid>

# default destination is the current database's incoming group
dt create-record --name "Inbox Note" --type markdown --content "Hello"
```

## Create from URL

```bash
# capture as markdown
dt create-from-url "https://example.com/article" --format markdown

# capture as PDF
dt create-from-url "https://example.com/article" --format pdf

# capture as web archive with readability mode
dt create-from-url "https://example.com/article" --format web-document --readability

# capture as formatted note with custom name
dt create-from-url "https://example.com" --format formatted-note --name "Reference Page"
```

## Update Content

```bash
# replace content
dt update-record-content <uuid> --content "New content here"

# append to existing content
dt update-record-content <uuid> --content "\n\n## Update" --append

# pipe content from stdin
echo "Content from stdin" | dt update-record-content <uuid>
```

## Set Record Properties

```bash
# set name and comment
dt set-record-properties <uuid> --name "Renamed" --comment "Updated via CLI"

# flag and mark unread
dt set-record-properties <uuid> --flag --unread

# unflag and mark read
dt set-record-properties <uuid> --unflag --read

# lock a record
dt set-record-properties <uuid> --locked

# replace tags
dt set-record-properties <uuid> --tags "tag1,tag2,tag3"

# exclude from AI chat and search
dt set-record-properties <uuid> --exclude-from-chat --exclude-from-search

# re-include in AI chat
dt set-record-properties <uuid> --include-in-chat

# exclude group from tagging (groups only)
dt set-record-properties <group-uuid> --exclude-from-tagging
```

## Organize Records

```bash
# move to a different group
dt move-record <uuid> <group-uuid>

# replicate (same database only)
dt replicate-record <uuid> <group-uuid>

# duplicate (can cross databases)
dt duplicate-record <uuid> <group-uuid>

# rename
dt rename-record <uuid> "Better Name"

# delete
dt delete-record <uuid>
```

## Tags

```bash
# add tags (comma-separated)
dt add-tags <uuid> work important follow-up

# remove tags
dt remove-tags <uuid> old-tag deprecated
```

## Convert Records

```bash
# convert to markdown
dt convert-record <uuid> markdown

# convert to PDF
dt convert-record <uuid> pdf

# convert to plain text in a specific group
dt convert-record <uuid> txt --group <group-uuid>

# convert to web archive
dt convert-record <uuid> webarchive

# convert to single-page PDF
dt convert-record <uuid> single-page-pdf
```

## Classification and Comparison

```bash
# get classification proposals
dt classify <uuid>

# classify using tag comparison
dt classify <uuid> --comparison tags

# propose tags instead of groups
dt classify <uuid> --tags

# classify within a specific database
dt classify <uuid> --database "Research"

# find similar records
dt compare <uuid>

# find similar using tag comparison
dt compare <uuid> --comparison tags

# compare two specific records
dt compare <uuid1> --compare-with <uuid2>
```

## AI Workflows

```bash
# ask about a document (defaults to DEVONthink's current engine/model)
dt ai-chat "Summarize this document" --record <uuid>

# ask with a specific engine
dt ai-chat "What are the key points?" --record <uuid> --engine claude

# ask with a specific local model
dt ai-chat "Summarize this note briefly" --record <uuid> --engine lmstudio --model "qwen3-coder-30b-a3b-instruct-mlx"

# ask about multiple documents
dt ai-chat "Compare these reports" --record <uuid1> --record <uuid2>

# adjust temperature
dt ai-chat "Be creative with this" --record <uuid> --temperature 1.5

# get JSON response
dt ai-chat "Extract key-value pairs" --record <uuid> --format json

# set a system role
dt ai-chat "Analyze this" --record <uuid> --role "You are a legal analyst"

# summarize records as markdown
dt ai-summarize <uuid1> <uuid2>

# summarize in rich text format
dt ai-summarize <uuid1> <uuid2> --format rich

# summarize into a specific group
dt ai-summarize <uuid1> <uuid2> --group <group-uuid>

# get tag suggestions
dt ai-suggest-tags <uuid>
```

## JSON Output Patterns

```bash
# any command with --json
dt search invoice --json
dt get-record-properties <uuid> --json
dt open-databases --json

# typical JSON result structure
# {"result": {...}}           — single result
# {"result": [{...}, ...]}   — multiple results
# {"error": "..."}           — error (on stderr)

# pipe to jq for filtering
dt search invoice --json | jq '.result[] | .uuid'
dt open-databases --json | jq '.result[] | .name'
```
