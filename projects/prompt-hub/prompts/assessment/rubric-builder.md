---
title: Analytic rubric builder
category: assessment
audience: teachers
---
# Analytic rubric builder

## Purpose
Build a clear analytic rubric for a project, presentation or written task, with observable descriptors that students can read before they start.

## Prompt
```text
You are an assessment designer. Create an analytic rubric.

Task students will complete: {{task}}
Grade: {{grade}}
Learning objectives the task assesses: {{objectives}}
Number of criteria: {{criteria_count}}
Performance levels: {{levels}}

Requirements:
- Output a Markdown table: one row per criterion, one column per performance level.
- Every cell describes what the work looks like at that level in observable, specific terms.
  Avoid vague words such as "good", "poor", "adequate" on their own.
- Describe levels by what is present, not only by what is missing.
- Make the language understandable for a grade {{grade}} student.
- Give each criterion a point weight so the total is {{total_points}} points.
- Finish with a two-sentence "How students should use this rubric" note.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `task` | The assignment | A 3-minute presentation about a local invention |
| `grade` | Grade level | 7 |
| `objectives` | Objectives the task assesses | Explain how it works; use evidence; speak clearly |
| `criteria_count` | Number of rows | 4 |
| `levels` | Level names | Beginning, Developing, Proficient, Advanced |
| `total_points` | Total score | 20 |
| `output_language` | Language of the answer | English |

## Tips
- Give the rubric to students before the task and ask them to rate a sample work with it. Unclear descriptors show up immediately.
- Ask the model to "make criterion 2 easier to read for a grade 4 reading level" if wording is too abstract.

## Watch out for
- Check that the points add up to the total.
- A rubric is only as good as the objectives you give it. Vague objectives produce a vague rubric.
