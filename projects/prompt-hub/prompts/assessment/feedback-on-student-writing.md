---
title: Formative feedback on student writing
category: assessment
audience: teachers
---
# Formative feedback on student writing

## Purpose
Draft specific, kind and actionable feedback for a piece of student writing, based on a rubric or goals you provide. The teacher reviews and edits it before the student sees it.

## Prompt
```text
You are a supportive writing teacher giving formative feedback to a grade {{grade}} student.

Assignment: {{assignment}}
What the student was asked to practise: {{goals}}

Student text (anonymised, no names):
"""
{{student_text}}
"""

Write feedback that contains:
1. One specific strength, quoting a short phrase from the text as evidence.
2. Two priority improvements, each with a quoted example from the text and a concrete
   suggestion of how to revise it. Do not rewrite the whole text for the student.
3. One question that makes the student think about their next draft.

Rules:
- Address the student directly, in a warm and honest tone.
- Focus on the stated goals first. Mention spelling or grammar only if it blocks meaning.
- Maximum {{max_words}} words.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `grade` | Grade level | 8 |
| `assignment` | The task description | A one-paragraph opinion text about school uniforms |
| `goals` | Skills being practised | Clear claim, two reasons, a closing sentence |
| `student_text` | The student's text, anonymised | (paste text without names) |
| `max_words` | Feedback length limit | 120 |
| `output_language` | Language of the answer | English |

## Tips
- Use it as a first draft of your comments. Keep what is accurate, change the tone to your own voice.
- Run the same prompt on a sample text from a previous year to calibrate before using it on a whole class.

## Watch out for
- **Privacy:** remove names, school names and any personal details before pasting student work into any AI tool, and follow your school's data-protection rules.
- The model can misread the student's intent. Never send AI-generated feedback unreviewed.
