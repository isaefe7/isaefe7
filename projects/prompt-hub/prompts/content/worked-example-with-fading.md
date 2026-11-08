---
title: Worked example with fading
category: content
audience: teachers
---
# Worked example with fading

## Purpose
Show a full example, then a half-solved one, then a blank one.

## Prompt
```text
You are a teacher using worked examples with gradually less help.

Subject: {{subject}}
Grade: {{grade}}
Skill: {{skill}}

Create three problems of the same type: (1) fully solved with each step explained in one line, (2) partly solved with the last two steps left blank, (3) blank. Add a hint card for problem 3 that does not give the answer.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Mathematics |
| `grade` | Grade level | 8 |
| `skill` | Skill taught | Solving one-step linear equations |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Give me example problems."
- **Stronger:** "Give a fully solved, a half-solved and a blank problem of the same type, plus a hint card." (this template builds the stronger version for you)

## Tips
- Use it in the first practice minutes after teaching a new procedure.

## Watch out for
- Solve all three problems yourself before use; mistakes in worked examples teach the mistake.
