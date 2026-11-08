---
title: Glossary from a text
category: content
audience: teachers
---
# Glossary from a text

## Purpose
Build a student glossary from the vocabulary of a lesson text.

## Prompt
```text
You are an educational editor.

Text:
{{text}}

Grade: {{grade}}
Create a glossary of the {{count}} terms a student most needs, sorted alphabetically. For each term give a definition at grade {{grade}} reading level and one example that is not in the text. Do not add terms that are not in the text.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `text` | Lesson text | Paste text here |
| `grade` | Grade level | 8 |
| `count` | Number of terms | 10 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Make a glossary."
- **Stronger:** "Create a 10-term alphabetical glossary only from the pasted text, with simple definitions and new examples." (this template builds the stronger version for you)

## Tips
- Ask students to add a drawing for each term.

## Watch out for
- Definitions may drift from your textbook. Compare against it.
