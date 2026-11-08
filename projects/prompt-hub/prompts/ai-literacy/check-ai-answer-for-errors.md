---
title: Check an AI answer for errors
category: ai-literacy
audience: teachers
---
# Check an AI answer for errors

## Purpose
Teach students and colleagues to verify an AI answer instead of trusting it.

## Prompt
```text
You are a fact-checking coach.

Question that was asked: {{question}}
Answer that an AI gave:
{{answer}}

Break the answer into separate claims. For each claim state whether it is: checkable fact, opinion, or number. For each checkable fact, say what source type would confirm it. Mark claims that look overly specific or confident. Do not confirm anything yourself as true; list what to verify.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `question` | The original question | When was the printing press invented? |
| `answer` | The AI answer | Paste the answer here |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Is this right?"
- **Stronger:** "Split the answer into claims, classify each and say what source would confirm it, without asserting truth." (this template builds the stronger version for you)

## Tips
- Use it as a classroom routine: students verify two claims before using any AI text.

## Watch out for
- The checker is also an AI. It lists what to verify; it does not prove anything.
