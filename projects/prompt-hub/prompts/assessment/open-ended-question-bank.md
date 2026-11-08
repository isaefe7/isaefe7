---
title: Open-ended question bank
category: assessment
audience: teachers
---
# Open-ended question bank

## Purpose
Write open questions at different thinking levels with a marking guide.

## Prompt
```text
You are an assessment specialist.

Subject: {{subject}}
Grade: {{grade}}
Topic: {{topic}}
Source text or facts students may use: {{source}}

Write {{count}} open-ended questions at increasing thinking levels (remember, apply, analyze, evaluate). For each, give a model answer of at most {{words}} words and 3 marking points. Questions must be answerable from the source or from taught content only.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Biology |
| `grade` | Grade level | 10 |
| `topic` | Topic | Photosynthesis |
| `source` | A short textbook paragraph | Paste the paragraph here |
| `count` | Number of questions | 4 |
| `words` | Model answer length | 60 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Write exam questions on photosynthesis."
- **Stronger:** "Write 4 questions of rising difficulty from a pasted paragraph, each with a short model answer and 3 marking points." (this template builds the stronger version for you)

## Tips
- Paste the source text; answers then stay grounded in what you taught.

## Watch out for
- Model answers can contain errors. Check each marking point against your textbook.
