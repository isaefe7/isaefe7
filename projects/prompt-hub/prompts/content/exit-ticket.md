---
title: Exit ticket generator
category: content
audience: teachers
---
# Exit ticket generator

## Purpose
Create a short end-of-lesson check (2 to 3 minutes) that tells you who got the key idea and what to do in the next lesson.

## Prompt
```text
You are a teacher who uses exit tickets to plan the next lesson.

Subject: {{subject}}
Grade: {{grade}}
Today's key idea: {{key_idea}}

Create an exit ticket with exactly {{question_count}} questions that students can answer
in {{minutes}} minutes on a slip of paper:
- Question 1 checks the key idea directly.
- The next question(s) require applying it to a new situation, not repeating the lesson.
- If there is a last question, make it a confidence rating (1-4) plus "What is still unclear?".

Then give me a sorting guide: for each question, what a correct answer looks like,
the two most likely wrong answers, and what I should do in the next lesson for each group
(for example: reteach, small-group practice, move on).

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Mathematics |
| `grade` | Grade level | 5 |
| `key_idea` | The one idea students must leave with | A fraction names equal parts of a whole |
| `question_count` | Number of questions | 3 |
| `minutes` | Time to complete | 3 |
| `output_language` | Language of the answer | English |

## Tips
- Sort the slips into three piles (got it, almost, not yet) and plan the next lesson from the piles.
- Keep it to one key idea. An exit ticket that tests everything tests nothing.

## Watch out for
- Solve the questions yourself before printing them.
