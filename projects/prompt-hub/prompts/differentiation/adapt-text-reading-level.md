---
title: Adapt a text to a lower reading level
category: differentiation
audience: teachers
---
# Adapt a text to a lower reading level

## Purpose
Rewrite a source text so that learners with weaker reading skills (or learners of the instruction language) can access the same ideas, without turning it into a different lesson.

## Prompt
```text
You are a literacy specialist. Adapt the text below for grade {{target_grade}} readers.

Rules:
- Keep every key idea and all key terms from this list: {{key_terms}}.
  Keep each key term, but add a short plain-language explanation the first time it appears.
- Use short sentences (about {{max_sentence_words}} words or fewer) and common words.
- Keep the original order of ideas. Do not add new facts and do not remove the main argument.
- Break long paragraphs into short ones and add a clear sub-heading every few paragraphs.
- Finish with a "Words to know" box and three comprehension questions
  (one literal, one inference, one opinion).
- Mark any place where you were unsure you kept the original meaning with [CHECK].

Original text:
"""
{{original_text}}
"""

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `target_grade` | Reading level to aim at | 4 |
| `key_terms` | Terms students must still meet | erosion, sediment, delta |
| `max_sentence_words` | Sentence length goal | 12 |
| `original_text` | The source text | (paste text) |
| `output_language` | Language of the answer | English |

## Tips
- Keep the original and the adapted text side by side in class so every student works on the same content.
- Ask the model to "list what you simplified or removed" to review the changes quickly.

## Watch out for
- Simplification can distort meaning, especially in science. Read every [CHECK] mark and compare technical sentences with the original.
- Respect copyright: only adapt texts you are allowed to modify.
