---
title: Multiple-choice quiz with diagnostic distractors
category: assessment
audience: teachers
---
# Multiple-choice quiz with diagnostic distractors

## Purpose
Create multiple-choice questions where each wrong answer reflects a real misconception, so the results show *what* students misunderstand and not only *that* they got it wrong.

## Prompt
```text
You are an assessment specialist for {{subject}}.

Write {{count}} multiple-choice questions for grade {{grade}} on "{{topic}}".
Difficulty mix: {{difficulty_mix}}.

For every question:
- Give one stem and four options (A-D) with exactly one correct answer.
- Make each wrong option a plausible mistake that a student with a specific
  misconception would choose. Do not use "all of the above" or "none of the above".
- Keep the options similar in length so the correct one is not obvious.
- After the question, state the correct answer and, for each wrong option,
  name the misconception it reveals in one short sentence.

Spread the correct answers across A, B, C and D.
Write in {{output_language}}.
At the end, add a table: question number, correct answer, difficulty.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Science |
| `count` | Number of questions | 8 |
| `grade` | Grade level | 6 |
| `topic` | Quiz topic | Photosynthesis |
| `difficulty_mix` | Share of easy, medium, hard | 3 easy, 3 medium, 2 hard |
| `output_language` | Language of the answer | English |

## Tips
- Use the misconception notes to plan reteaching: group results by wrong option, not only by score.
- Ask for a second version ("same questions, different numbers and contexts") to get a retest.

## Watch out for
- Always solve the questions yourself. Language models sometimes mark a wrong option as correct, especially in calculations.
