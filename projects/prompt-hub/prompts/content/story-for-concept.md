---
title: Short story that teaches a concept
category: content
audience: teachers
---
# Short story that teaches a concept

## Purpose
Explain an abstract idea through a short story with a check afterwards.

## Prompt
```text
You are a children's author and teacher.

Concept: {{concept}}
Grade: {{grade}}
Setting familiar to students: {{setting}}

Write a story of about {{words}} words that shows the concept through events, not by lecturing. Do not use real people or brands. After the story write {{count}} questions that check whether students understood the concept, and one that asks where the story is not like real life.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `concept` | Concept to teach | Supply and demand |
| `grade` | Grade level | 6 |
| `setting` | Familiar setting | A school canteen |
| `words` | Story length | 250 |
| `count` | Number of check questions | 3 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Write a story about economics."
- **Stronger:** "Write a 250-word school canteen story showing supply and demand, with 3 check questions and one 'where is this not real life' question." (this template builds the stronger version for you)

## Tips
- Read the story aloud, then ask the last question: it prevents false generalisation.

## Watch out for
- Stories simplify. Name one thing the story leaves out.
