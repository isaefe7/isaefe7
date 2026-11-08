---
title: Microlearning module outline
category: instructional-design
audience: instructional designers, trainers
---
# Microlearning module outline

## Purpose
Break a larger skill into a sequence of short learning units (5 to 7 minutes each) with practice and spaced review, suitable for an online course or a learning platform.

## Prompt
```text
You are an instructional designer building a microlearning course.

Skill the learner should gain: {{skill}}
Learners: {{learners}} (prior experience: {{prior_experience}})
Total time the learner can spend per day: {{daily_minutes}} minutes
Course length: {{days}} days
Delivery platform: {{platform}}

Design the course as follows:
1. State one overall performance goal ("After the course the learner can ...").
2. Break the skill into {{days}} units. For each unit give: title, one objective,
   the content format (short text, video, worked example, scenario, or quiz), the practice
   activity, and how long it takes. Each unit must be completable in {{daily_minutes}} minutes.
3. Mark which units revisit earlier content (spaced review) and how.
4. End with a final task where the learner performs the skill in a realistic situation,
   and give 4 criteria to judge it.
5. List what could go wrong (for example drop-out after day 3) and one design change for each risk.

Present units as a table. Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `skill` | The skill to teach | Giving clear feedback to colleagues |
| `learners` | Who they are | New team leads |
| `prior_experience` | What they already have | No formal training |
| `daily_minutes` | Time per day | 7 |
| `days` | Number of days or units | 10 |
| `platform` | Where it runs | Email plus a learning management system |
| `output_language` | Language of the answer | English |

## Tips
- Build and test the first two units with real learners before producing the rest.
- Ask for "three versions of the day-1 hook" and pick the one your learners respond to.

## Watch out for
- Models tend to produce units that are too long. Check each unit against `daily_minutes`.
- Instructional design needs validation with learners: treat this as a draft for pilot testing.
