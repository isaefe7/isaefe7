---
title: Prompt improvement coach
category: ai-literacy
audience: everyone
---
# Prompt improvement coach

## Purpose
Get your own prompt improved and learn why each change helps.

## Prompt
```text
You are a prompt engineering coach.

My goal: {{goal}}
My prompt:
{{prompt}}

1. List what is missing or unclear (role, audience, format, constraints, examples, length).
2. Rewrite the prompt using {{variable_style}} placeholders for the parts I should fill in.
3. For each change, explain in one line why it should improve the answer.
Do not answer my prompt; improve it.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `goal` | What you want | A lesson plan for fractions |
| `prompt` | Your current prompt | Make a lesson plan about fractions |
| `variable_style` | Placeholder style | double curly braces |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Make my prompt better."
- **Stronger:** "List what is missing, rewrite with placeholders and explain each change in one line." (this template builds the stronger version for you)

## Tips
- Test both prompts side by side with the same input and compare.

## Watch out for
- A better-looking prompt is not always better. Compare outputs.
