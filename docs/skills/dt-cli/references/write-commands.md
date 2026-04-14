# Write Commands

Use these commands after resolving the target database, record, and destination.

## Create

```bash
dt create-record --name <name> [--type <type>] [--content <text>] [--url <url>] [--comment <text>] [--tags <csv>] [--group <group>]
dt create-from-url <url> [--format <format>] [--name <name>] [--group <group>] [--pdf-pagination] [--pdf-width <width>] [--readability]
```

`create-record` types accepted by the implementation:

- `text`, `txt`
- `markdown`
- `html`
- `rtf`
- `bookmark`
- `group`
- `formatted-note`

Notes:

- If `--group` is omitted, `create-record` uses the current database's
  incoming group.
- If `--group` is omitted, `create-from-url` also uses the current database's
  incoming group.
- `create-from-url` formats: `pdf`, `webarchive`, `markdown`, `formatted-note`

## Update and Properties

```bash
dt update-record-content <identifier> [--content <text>] [--append]
dt set-record-properties [identifier] [options]
dt rename-record <identifier> <new-name>
```

Important `set-record-properties` options:

- `--name <name>`
- `--comment <comment>`
- `--url <url>`
- `--tags <csv>`
- `--unread` / `--read`
- `--flag` / `--unflag`
- `--locked` / `--unlocked`
- `--exclude-from-chat` / `--include-in-chat`
- `--exclude-from-classification` / `--include-in-classification`
- `--exclude-from-search` / `--include-in-search`
- `--exclude-from-see-also` / `--include-in-see-also`
- `--exclude-from-tagging` / `--include-in-tagging`
- `--exclude-from-wiki-linking` / `--include-in-wiki-linking`

## Organize and Delete

```bash
dt move-record <identifier> <destination>
dt replicate-record <identifier> <destination>
dt duplicate-record <identifier> <destination>
dt delete-record <identifier> [--from <group>]
dt convert-record <identifier> <to-format> [--group <group>]
```

Notes:

- `replicate-record` requires source and destination to be in the same database.
- `duplicate-record` can be used to create a copy into a destination group.
- `delete-record --from <group>` removes only one instance from a specific group.

`convert-record` target formats:

- `txt`
- `rtf`
- `formatted-note`
- `html`
- `markdown`
- `bookmark`
- `webarchive`
- `pdf`
- `single-page-pdf`

## Tags

```bash
dt add-tags [identifier] <tag>...
dt remove-tags [identifier] <tag>...
```

These commands take tags as positional arguments, not `--tags`.
