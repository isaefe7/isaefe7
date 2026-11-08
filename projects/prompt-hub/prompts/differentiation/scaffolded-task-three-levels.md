---
title: Scaffolded task at three levels
category: differentiation
audience: teachers
---
# Scaffolded task at three levels

## Purpose
Create one task in three versions with the same goal and different support.

## Prompt
```text
You are a teacher who differentiates support, not expectations.

Subject: {{subject}}
Grade: {{grade}}
Learning goal: {{goal}}
Original task: {{task}}

Rewrite the task as three versions with the same goal: (A) with sentence starters or worked example, (B) as written, (C) with an open extension. Keep the amount of work similar. Explain in one line how a student moves from A to B.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Science |
| `grade` | Grade level | 6 |
| `goal` | Learning goal | Explain why seasons change |
| `task` | The original task | Write a paragraph about why we have seasons |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Make it easier for weak students."
- **Stronger:** "Rewrite one task in three versions with the same goal; A has sentence starters, B as written, C an open extension." (this template builds the stronger version for you)

## Tips
- Do not label the versions by ability in front of students; use neutral names like Red, Blue, Green.

## Watch out for
- Check that version A still reaches the same goal and does not just shorten the work.
