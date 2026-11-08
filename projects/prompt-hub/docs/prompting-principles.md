# Prompting principles for educators

The prompts in this repository follow the same few principles. They apply to any generative AI tool.

## 1. Give the model a role, a task and a reader

Say who the model is ("an experienced grade 5 mathematics teacher"), what it must produce, and who will read the result ("a new teacher", "a grade 7 student"). The reader decides vocabulary and length.

## 2. State constraints as numbers and checks

"Make it short" is ambiguous. "Maximum 120 words", "exactly 40 minutes in total", "exactly 3 objectives" can be checked, by you or by code. Every prompt here has at least one constraint you can verify in ten seconds.

## 3. Show the shape of the answer

Ask for a table, a numbered list or a JSON object with named fields. A defined shape makes answers comparable and makes them easy to copy into a worksheet, a slide or a program. See [`lesson-plan-assistant`](https://github.com/isaefe7/isaefe7/tree/main/projects/lesson-plan-assistant) for a tool that validates a JSON answer in code.

## 4. Put your real context in the variables

Class size, available materials, prior knowledge and the exact curriculum outcome change the answer more than any clever wording. Copy the outcome text from your curriculum instead of paraphrasing it.

## 5. Ask the model to mark its own uncertainty

Phrases such as "mark anything you are unsure about with [CHECK]" or "name the misconception each wrong option reveals" turn the answer into something you can review quickly.

## 6. Iterate with short follow-ups

Do not rewrite a long prompt. Reply with one change: "Shorten the warm-up to 5 minutes and rebalance the rest", "make activity 2 work without a projector".

## 7. Verify before you use

Language models can be fluent and wrong, especially in calculations, dates, scientific details and references.

- Solve every question you generate.
- Check facts against a textbook or another trusted source.
- Never ask for, or trust, citations you cannot open.

## 8. Protect student data

- Never paste names, photos, grades, identification numbers or anything that identifies a child.
- Anonymise student work before using it as input.
- Follow your school's and your country's data-protection rules, and check the privacy terms of the tool you use.

## 9. Keep the teacher in charge

AI output is a first draft. The teacher decides what happens in the classroom, and is responsible for the final material, feedback and grades.

## Checklist before you share a prompt

- [ ] Has a role, a task, a reader and an output shape
- [ ] At least one numeric constraint that can be verified
- [ ] Every `{{variable}}` is explained with an example
- [ ] A "Watch out for" note about how the answer can be wrong
- [ ] No personal data in the example values
