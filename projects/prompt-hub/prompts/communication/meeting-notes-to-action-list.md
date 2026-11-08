---
title: Meeting notes to action list
category: communication
audience: everyone
---
# Meeting notes to action list

## Purpose
Turn messy notes from a school or team meeting into decisions and tasks.

## Prompt
```text
You are a meeting secretary.

Meeting notes:
{{notes}}

Produce: (1) decisions made, (2) action items as a table with owner, task and deadline, (3) open questions. Use only information in the notes. If an owner or deadline is missing, write "not stated" instead of guessing.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `notes` | Raw notes | Paste notes here |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Summarise this meeting."
- **Stronger:** "Extract decisions, an owner-task-deadline table and open questions, writing 'not stated' where information is missing." (this template builds the stronger version for you)

## Tips
- Send the list within a day while memory is fresh.

## Watch out for
- Do not paste confidential or personal data into tools you are not allowed to use for that.
