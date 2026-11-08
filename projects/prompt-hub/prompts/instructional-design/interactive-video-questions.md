---
title: Interactive video questions
category: instructional-design
audience: instructional designers
---
# Interactive video questions

## Purpose
Place questions at the right moments in an educational video.

## Prompt
```text
You are an instructional designer for interactive video.

Video topic: {{topic}}
Length: {{minutes}} minutes
Transcript or outline:
{{outline}}

Choose {{count}} points where a question should pause the video. For each give: the time, the question, the answer options, the feedback for a right and a wrong answer, and why the pause belongs there. Do not interrupt in the middle of an explanation.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `topic` | Video topic | Binary numbers |
| `minutes` | Video length | 6 |
| `outline` | Transcript or outline | Paste outline here |
| `count` | Number of questions | 3 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Add questions to my video."
- **Stronger:** "Choose 3 pause points with questions, feedback for right and wrong answers and a reason for each time." (this template builds the stronger version for you)

## Tips
- Questions right after a key idea help recall; questions before it prime attention.

## Watch out for
- Times are estimates from the outline; check them against the real video.
