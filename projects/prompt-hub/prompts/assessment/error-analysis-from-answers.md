---
title: Error analysis from student answers
category: assessment
audience: teachers
---
# Error analysis from student answers

## Purpose
Find patterns in wrong answers so you reteach the right thing.

## Prompt
```text
You are a teacher analysing common errors.

Subject: {{subject}}
Question: {{question}}
Correct answer: {{correct_answer}}
Anonymous student answers (no names):
{{answers}}

Group the wrong answers by the likely misconception behind them. For each group give: a name, how many answers, one sentence explaining the misconception, and a 5-minute reteaching move. Say clearly when an answer is too unclear to classify.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Mathematics |
| `question` | The question | What is 3/4 + 1/4? |
| `correct_answer` | Correct answer | 1 |
| `answers` | Pasted anonymous answers | 4/8; 1; 4/4; 3/8 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Why did students get it wrong?"
- **Stronger:** "Group the pasted answers by misconception, count each group and give one reteaching move per group." (this template builds the stronger version for you)

## Tips
- Remove names before pasting. Use initials or numbers.

## Watch out for
- The model guesses at causes. Confirm a misconception by asking two students.
