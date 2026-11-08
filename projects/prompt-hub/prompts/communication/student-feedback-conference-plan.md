---
title: Student conference plan
category: communication
audience: teachers
---
# Student conference plan

## Purpose
Prepare a short one-to-one talk about progress that ends with a plan.

## Prompt
```text
You are a teacher preparing a 5-minute conference with a student.

Subject: {{subject}}
Strength I observed: {{strength}}
Area to improve: {{improve}}
Evidence from the student's work (no names): {{evidence}}

Write: an opening sentence, three questions that let the student describe their own progress, how to present the area to improve without blame, and a one-line goal for the next two weeks that can be checked.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | Subject | Mathematics |
| `strength` | Strength | Explains reasoning clearly |
| `improve` | Area to improve | Checks work for errors |
| `evidence` | Evidence | Three tests: calculation slips in the last step |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "How do I talk to this student?"
- **Stronger:** "Prepare an opening, three questions, a non-blaming way to name the improvement area, and a checkable two-week goal." (this template builds the stronger version for you)

## Tips
- End with the student restating the goal in their own words.

## Watch out for
- Do not add private details. Keep the focus on observable work.
