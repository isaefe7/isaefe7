---
title: Explain a concept with analogies and a check for understanding
category: content
audience: teachers
---
# Explain a concept with analogies and a check for understanding

## Purpose
Prepare a clear explanation of a difficult concept using everyday analogies, and learn where each analogy stops being accurate.

## Prompt
```text
You are a teacher who is known for explaining difficult ideas simply.

Explain "{{concept}}" to grade {{grade}} students in {{subject}}.

Give:
1. A two-sentence plain-language definition.
2. {{analogy_count}} different everyday analogies from things grade {{grade}} students know
   (for example: {{student_interests}}).
3. For each analogy, one sentence saying where the analogy breaks down, so I can warn students.
4. One common misconception about the concept and a short way to correct it.
5. Two questions I can ask to check understanding: one that a student can answer by
   repeating the explanation, and one that needs them to apply it to a new situation.

Do not use technical words that are not in this list unless you explain them: {{allowed_terms}}.
Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `concept` | The concept to explain | Variables in programming |
| `grade` | Grade level | 6 |
| `subject` | School subject | Information technology |
| `analogy_count` | Number of analogies | 3 |
| `student_interests` | Contexts your students know | football, school bags, phones |
| `allowed_terms` | Terms students already know | program, computer, value |
| `output_language` | Language of the answer | English |

## Tips
- The "where it breaks down" lines are the most valuable part. A good analogy with known limits teaches more than a perfect-sounding one.
- Replace `student_interests` with what your actual class likes.

## Watch out for
- An analogy can create a misconception of its own. Test it with a colleague or with a few students before building a lesson on it.
