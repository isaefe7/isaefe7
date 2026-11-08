---
title: Classroom AI-use policy draft
category: ai-literacy
audience: teachers
---
# Classroom AI-use policy draft

## Purpose
Draft clear rules for when students may and may not use AI.

## Prompt
```text
You are a school policy writer.

School level: {{grade}}
Subject: {{subject}}
Allowed uses I want: {{allowed}}
Not allowed: {{not_allowed}}

Draft a one-page classroom AI-use policy in student-friendly language with: purpose, three allowed uses with an example each, three not-allowed uses with an example each, how students must say when they used AI, and what happens if the rule is broken. Do not invent school rules or laws; mark places I must adapt.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `grade` | School level | Grade 9 |
| `subject` | Subject | Social studies |
| `allowed` | Allowed uses | Brainstorming, explaining a concept, checking grammar |
| `not_allowed` | Not allowed | Writing the whole assignment, test answers |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Write an AI policy."
- **Stronger:** "Draft a one-page policy with examples of allowed and not-allowed uses, a disclosure line and places to adapt." (this template builds the stronger version for you)

## Tips
- Discuss the draft with students; rules they helped write are followed more.

## Watch out for
- Check against your school's and country's rules before publishing.
