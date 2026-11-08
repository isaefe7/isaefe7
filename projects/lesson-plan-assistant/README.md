# Lesson Plan Assistant

A small Python command-line tool that asks a **Claude** model for a school lesson plan and then **checks the answer with code** before showing it, instead of trusting the model blindly.

It is a first step toward a larger idea of mine: reusable, tested prompts for teachers. The prompt library lives in [`prompt-hub`](https://github.com/isaefe7/isaefe7/tree/main/projects/prompt-hub).

```text
request ──► prompt ──► Claude ──► JSON ──► validate ──► Markdown plan
                         ▲                     │
                         └── repair prompt ◄───┘  (once, with the list of problems)
```

## Why it is built this way

| Decision | Reason |
|---|---|
| The model must return **one JSON object** | Output can be parsed and checked by code, not just read. |
| Every constraint is written explicitly in the prompt (grade, duration, number of objectives, language) | Vague prompts give vague plans. |
| `validate_plan()` returns a **list of problems** | The same list is sent back to the model for one repair attempt, and works as a tiny evaluation for any plan. |
| Checks are deterministic: right grade and duration, exact number of objectives, 3–6 activities, **activity minutes add up to the lesson length**, at least two differentiation ideas | These are the mistakes language models actually make (for example plans that last 47 minutes in a 40-minute lesson). |
| The Anthropic SDK is imported **lazily** and the client is injectable | Everything except the API call is testable offline with a fake client. |

## Installation

Requires Python 3.10+.

```bash
git clone https://github.com/isaefe7/isaefe7.git
cd isaefe7/projects/lesson-plan-assistant
pip install -e ".[dev]"
export ANTHROPIC_API_KEY="your-key"        # Windows PowerShell: $env:ANTHROPIC_API_KEY="your-key"
```

## Usage

```bash
lesson-plan-assistant "Fractions" --subject Mathematics --grade 5 --duration 40 --lang en

# Turkish output, extra context for the model, save to a file
lesson-plan-assistant "Kesirler" --subject Matematik --grade 5 --lang tr \
    --notes "28 öğrencili sınıf, projeksiyon yok" --out kesirler.md

# See exactly what would be sent, without calling the API (no key needed)
lesson-plan-assistant "Fractions" --subject Mathematics --grade 5 --dry-run
```

| Option | Default | Meaning |
|---|---|---|
| `--subject` | required | Subject, e.g. `Mathematics` |
| `--grade` | required | Grade level, 1–12 |
| `--duration` | 40 | Lesson length in minutes (10–180) |
| `--objectives` | 3 | Number of learning objectives (1–6) |
| `--lang` | `tr` | Output language: `tr` or `en` |
| `--notes` | empty | Extra context for the model |
| `--model` | `claude-sonnet-5-5` | Model id; can also be set with `ANTHROPIC_MODEL` |
| `--out` | stdout | Write the Markdown plan to a file |
| `--dry-run` | off | Print the prompt and exit |

The exact prompt for a sample request is in [`examples/dry-run-prompt.txt`](examples/dry-run-prompt.txt).

## Project layout

```text
src/lesson_plan_assistant/
├── models.py    # LessonRequest: validated input
├── prompt.py    # system prompt, user prompt, repair prompt
├── client.py    # API call, JSON extraction, one repair attempt
├── schema.py    # validate_plan(): deterministic checks
├── render.py    # plan -> Markdown
└── cli.py       # command-line interface
tests/           # 31 tests, no network or API key needed
```

## Tests

```bash
pytest -q
```

The tests use a fake client that mimics `anthropic.Anthropic().messages.create`. They cover prompt content, every validation rule, JSON extraction (including code fences), the repair loop, giving up after the repair attempt, the missing-API-key error, Markdown rendering and the CLI.

## Limitations

- **Not tested against the live API by the author's test suite.** The API call is a thin wrapper around `client.messages.create`; the tests verify everything around it. Please run a real request with your own key before relying on it.
- The checks verify the *structure* and arithmetic of a plan, not its pedagogical quality. A teacher still has to read the plan.
- Two output languages (Turkish, English) and a single plan format for now.

## License

[MIT](LICENSE) © 2026 İsa Efe
