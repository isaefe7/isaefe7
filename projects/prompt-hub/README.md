# Prompt Hub

A small, tested collection of **prompt templates for teachers and instructional designers**: lesson planning, assessment, differentiation, content and video design.

Each prompt is a plain Markdown file with a purpose, a template with `{{variables}}`, example values, usage tips and a "watch out for" note about how the answer can go wrong. A script checks that every template is well-formed, so the library stays consistent as it grows.

This is the seed of a bigger idea of mine: a community platform where educators share and improve prompts for generative AI. The first working tool built on these ideas is [`lesson-plan-assistant`](https://github.com/isaefe7/isaefe7/tree/main/projects/lesson-plan-assistant).

> 🇹🇷 **Türkçe özet:** Öğretmenler ve öğretim tasarımcıları için hazırlanmış prompt şablonları. Şablonlardaki `{{değişkenleri}}` kendi sınıfınıza göre doldurun, çıktıyı mutlaka kontrol edin ve öğrenci verisi paylaşmayın. Şablonlar İngilizce yazılmıştır; `output_language` değişkenine "Türkçe" yazarak Türkçe çıktı alabilirsiniz.

## Prompts

<!-- INDEX:START -->
| Category | Prompt | Variables |
|---|---|---|
| ai-literacy | [Check an AI answer for errors](prompts/ai-literacy/check-ai-answer-for-errors.md) | 3 |
| ai-literacy | [Prompt improvement coach](prompts/ai-literacy/prompt-improvement-coach.md) | 4 |
| ai-literacy | [Classroom AI-use policy draft](prompts/ai-literacy/student-ai-use-policy-draft.md) | 5 |
| assessment | [Error analysis from student answers](prompts/assessment/error-analysis-from-answers.md) | 5 |
| assessment | [Formative feedback on student writing](prompts/assessment/feedback-on-student-writing.md) | 6 |
| assessment | [Multiple-choice quiz with diagnostic distractors](prompts/assessment/multiple-choice-quiz.md) | 6 |
| assessment | [Open-ended question bank](prompts/assessment/open-ended-question-bank.md) | 7 |
| assessment | [Analytic rubric builder](prompts/assessment/rubric-builder.md) | 7 |
| assessment | [Student self-assessment checklist](prompts/assessment/self-assessment-checklist.md) | 5 |
| communication | [Meeting notes to action list](prompts/communication/meeting-notes-to-action-list.md) | 2 |
| communication | [Message to parents](prompts/communication/parent-message-draft.md) | 6 |
| communication | [Student conference plan](prompts/communication/student-feedback-conference-plan.md) | 5 |
| content | [Exit ticket generator](prompts/content/exit-ticket.md) | 6 |
| content | [Explain a concept with analogies and a check for understanding](prompts/content/explain-with-analogies.md) | 7 |
| content | [Glossary from a text](prompts/content/glossary-from-text.md) | 4 |
| content | [Short story that teaches a concept](prompts/content/story-for-concept.md) | 6 |
| content | [Worked example with fading](prompts/content/worked-example-with-fading.md) | 4 |
| differentiation | [Adapt a text to a lower reading level](prompts/differentiation/adapt-text-reading-level.md) | 5 |
| differentiation | [Extension tasks for advanced learners](prompts/differentiation/extension-tasks.md) | 8 |
| differentiation | [Reading questions by level](prompts/differentiation/reading-comprehension-questions-levels.md) | 4 |
| differentiation | [Scaffolded task at three levels](prompts/differentiation/scaffolded-task-three-levels.md) | 5 |
| differentiation | [Vocabulary support for language learners](prompts/differentiation/vocabulary-support-multilingual.md) | 6 |
| instructional-design | [Educational video storyboard](prompts/instructional-design/educational-video-storyboard.md) | 7 |
| instructional-design | [Feedback messages for quiz answers](prompts/instructional-design/feedback-for-quiz-answers.md) | 5 |
| instructional-design | [Interactive video questions](prompts/instructional-design/interactive-video-questions.md) | 5 |
| instructional-design | [Learner persona](prompts/instructional-design/learner-persona.md) | 4 |
| instructional-design | [Objectives to assessment map](prompts/instructional-design/learning-objectives-to-assessment-map.md) | 5 |
| instructional-design | [Microlearning module outline](prompts/instructional-design/microlearning-module-outline.md) | 7 |
| lesson-planning | [Measurable learning objectives (Bloom's taxonomy)](prompts/lesson-planning/learning-objectives-bloom.md) | 6 |
| lesson-planning | [Lesson plan with the 5E model](prompts/lesson-planning/lesson-plan-5e.md) | 8 |
| lesson-planning | [Station rotation plan](prompts/lesson-planning/station-rotation-plan.md) | 8 |
| lesson-planning | [Unit plan with backward design](prompts/lesson-planning/unit-plan-backward-design.md) | 6 |
| lesson-planning | [Warm-up activities](prompts/lesson-planning/warm-up-activities.md) | 7 |
<!-- INDEX:END -->

## How to use a prompt

1. Open a prompt file and copy the text block under **Prompt**.
2. Replace every `{{variable}}` with your own values. The **Variables** table gives an example for each one.
3. Paste it into the AI tool you use. To get output in Turkish, set `output_language` to `Turkish`.
4. Read the result critically (see **Watch out for** in each file) and edit it before it reaches students.

Read [docs/prompting-principles.md](docs/prompting-principles.md) for the ideas behind the templates and for guidance on protecting student data.

## Quality checks

```bash
python scripts/check_prompts.py                 # validate all prompts
python scripts/check_prompts.py --write-index   # also refresh the table above
pip install pytest && pytest -q                 # tests for the checker
```

The checker verifies that every file has the required front matter and sections, that the category matches the folder, that there is exactly one prompt block, and that **every `{{variable}}` in the template is documented and every documented variable is used**.

It checks structure, not whether an answer is good. Quality still depends on a teacher reading the output.

## Contributing

New prompts and improvements are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © 2026 İsa Efe
