---
title: Learner persona
category: instructional-design
audience: instructional designers
---
# Learner persona

## Purpose
Describe a typical learner so design decisions can be tested against a person.

## Prompt
```text
You are a learning experience researcher.

Course: {{course}}
Audience description: {{audience}}
Context in which they learn: {{context}}

Write a persona (use an invented name) with: goals, prior knowledge, constraints (time, devices, language), motivations, likely frustrations, and three design implications for this course. State clearly which details come from my description and which are assumptions to verify with real learners.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `course` | Course | Excel basics for office workers |
| `audience` | Audience description | Adults 30-50, little technical background |
| `context` | Learning context | Evening, phone, 20 minutes per day |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Describe my learners."
- **Stronger:** "Write a persona with goals, constraints and design implications, and separate facts from assumptions." (this template builds the stronger version for you)

## Tips
- Verify the assumptions with 3 to 5 real learners.

## Watch out for
- A persona is a hypothesis, not data. Do not present it as research.
