# AI Commands

These commands use DEVONthink classification, similarity, summarization, and
chat features.

## Classification and Comparison

```bash
dt classify [identifier] [--comparison <data|tags>] [--tags] [--database <name>]
dt compare [identifier] [--compare-with <identifier>] [--comparison <data|tags>] [--database <name>]
dt ai-suggest-tags [identifier]
```

Notes:

- `classify --tags` asks DEVONthink for tag proposals instead of group proposals.
- `compare` without `--compare-with` returns similar records.
- `compare --compare-with <identifier>` performs a direct two-record comparison.
- `ai-suggest-tags` returns a list of tag names.

## Summarization

```bash
dt ai-summarize <identifiers>... [--format <markdown|simple|rich>] [--group <group>]
```

Notes:

- DEVONthink creates a summary record and the CLI returns that record.
- If `--group` is omitted, DEVONthink chooses the default destination.

## Chat

```bash
dt ai-chat <message> [--record <identifier> ...] [--model <model>] [--role <role>] [--engine <engine>] [--temperature <temperature>] [--format <text|json|html>]
```

Supported engines:

- `chatgpt`
- `claude`
- `gemini`
- `mistral`
- `apple-intelligence`
- `perplexity`
- `openrouter`
- `openai-compatible`
- `lmstudio`
- `ollama`
- `remote-ollama`

Important behavior:

- If `--engine` is omitted, the CLI uses DEVONthink's current chat engine.
- If `--model` is omitted and no explicit engine is supplied, the CLI uses
  DEVONthink's current chat model.
- `--record` provides context records. The current implementation passes the
  first resolved record as the primary chat context.
- `--format json` changes the output format request sent to DEVONthink chat.

## Live-Verified AI Patterns

```bash
dt ai-suggest-tags 22511 --json
dt ai-summarize 22511 --json
dt ai-chat "Summarize this note briefly" --record 22511 --json
```
