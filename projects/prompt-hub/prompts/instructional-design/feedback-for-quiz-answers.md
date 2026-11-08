---
title: Feedback messages for quiz answers
category: instructional-design
audience: instructional designers
---
# Feedback messages for quiz answers

## Purpose
Write feedback that explains instead of only saying right or wrong.

## Prompt
```text
You are an instructional designer who writes feedback for online quizzes.

Question: {{question}}
Options: {{options}}
Correct option: {{correct}}

For each option write feedback of at most {{words}} words. For wrong options, name the likely misconception, explain why it fails and point to where to review. For the right option, add why it works. Never use "wrong" or "incorrect" as the opening word.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `question` | Question | Which unit measures electrical current? |
| `options` | Answer options | A volt B ampere C ohm D watt |
| `correct` | Correct option | B |
| `words` | Max words per feedback | 25 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Write feedback for answers."
- **Stronger:** "Write short feedback per option that names the misconception and points to a review spot." (this template builds the stronger version for you)

## Tips
- Show the feedback immediately and let the learner retry.

## Watch out for
- Misconceptions are guessed. Check them against real wrong answers when you have data.
