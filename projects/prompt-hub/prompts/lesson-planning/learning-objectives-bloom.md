---
title: Measurable learning objectives (Bloom's taxonomy)
category: lesson-planning
audience: teachers
---
# Measurable learning objectives (Bloom's taxonomy)

## Purpose
Turn a vague topic ("students will understand fractions") into specific, observable objectives at different cognitive levels.

## Prompt
```text
You are an instructional designer. Write learning objectives for this lesson.

Subject: {{subject}}
Grade: {{grade}}
Topic: {{topic}}
Curriculum outcome or standard (if any): {{standard}}

Rules:
- Write {{count}} objectives.
- Start every objective with an observable action verb from Bloom's revised taxonomy.
  Do not use "understand", "know", "learn" or "appreciate".
- Cover at least three different cognitive levels and label each objective with its level.
- Each objective must say what the student will produce or do, and how well.
- After the list, add a table with columns: objective, level, one way to assess it.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Mathematics |
| `grade` | Grade level | 5 |
| `topic` | Lesson topic | Comparing fractions |
| `standard` | Official outcome code or text, or "none" | none |
| `count` | How many objectives | 4 |
| `output_language` | Language of the answer | English |

## Tips
- Paste the exact wording of the curriculum outcome into `standard`; the objectives will align with it much better.
- If every objective ends up at "remember" level, ask for "at least one apply and one analyze objective".

## Watch out for
- The assessment ideas in the table are suggestions. Make sure they match what you will actually do in class.
