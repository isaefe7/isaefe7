---
title: Student self-assessment checklist
category: assessment
audience: teachers
---
# Student self-assessment checklist

## Purpose
Turn a task into a checklist students use to judge their own work before handing it in.

## Prompt
```text
You are a teacher who builds self-assessment tools for students.

Task students completed: {{task}}
Grade: {{grade}}
Success criteria: {{criteria}}

Write a checklist of {{item_count}} items in student-friendly language ("I can...", "I included..."). Each item must be answerable with yes, partly or not yet and must point to something visible in the work. Add two reflection questions about what to improve next.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `task` | The task | A one-page opinion text |
| `grade` | Grade level | 8 |
| `criteria` | What good work looks like | Clear opinion, two reasons, one example, a conclusion |
| `item_count` | Number of items | 6 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Make a checklist for the essay."
- **Stronger:** "Make a 6-item 'I can' checklist for an opinion text that each point to something visible, plus two reflection questions." (this template builds the stronger version for you)

## Tips
- Let students use the checklist on a sample answer first so they learn how to judge.

## Watch out for
- Students tend to rate themselves high. Compare a few checklists with your own marking.
