---
title: Vocabulary support for language learners
category: differentiation
audience: teachers
---
# Vocabulary support for language learners

## Purpose
Prepare key words, simple definitions and visuals ideas before a lesson.

## Prompt
```text
You are a teacher who supports students learning the language of instruction.

Subject: {{subject}}
Grade: {{grade}}
Lesson text or topic: {{text}}
Students' home language (for cognates): {{home_language}}

Pick the {{count}} most important words students need. For each, give: a simple definition in 10 words or fewer, an example sentence about the lesson, a simple picture or gesture idea, and a cognate in {{home_language}} only if you are sure one exists.

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `subject` | School subject | Science |
| `grade` | Grade level | 5 |
| `text` | Lesson text or topic | How plants make food |
| `home_language` | Students' home language | Arabic |
| `count` | Number of words | 8 |
| `output_language` | Language of the answer | English |

## Weak vs stronger request
- **Weak:** "Give me word lists for refugee students."
- **Stronger:** "Select 8 key words with 10-word definitions, example sentences and picture ideas; include cognates only if sure." (this template builds the stronger version for you)

## Tips
- Teach the words before the text, not during it.

## Watch out for
- Cognates can be false friends. Ask a speaker of the language before you use any.
