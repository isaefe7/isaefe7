---
title: Objectives to assessment map
category: instructional-design
audience: instructional designers
---
# Objectives to assessment map

## Purpose
Check that every objective has an activity and an assessment.

## Prompt
```text
You are an instructional designer doing an alignment review.

Course or module: {{module}}
Objectives:
{{objectives}}
Planned activities:
{{activities}}
Planned assessments:
{{assessments}}

Build a table: objective, matching activity, matching assessment, and a gap note. Mark any objective that has no activity or no assessment, and any activity that supports no objective. Finish with the three most important fixes.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `module` | Course or module | Intro to databases |
| `objectives` | List of objectives | 1. Draw an ER diagram 2. Write SELECT queries |
| `activities` | List of activities | Lecture, lab 1, lab 2 |
| `assessments` | List of assessments | Quiz, final project |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Check my course design."
- **Stronger:** "Build an alignment table of objectives, activities and assessments, flag gaps, and list three fixes." (this template builds the stronger version for you)

## Tips
- Run it before you build materials, not after.

## Watch out for
- The model matches by wording only. Judge yourself whether the match is real.
