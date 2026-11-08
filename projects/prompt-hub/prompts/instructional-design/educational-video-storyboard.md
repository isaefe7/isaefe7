---
title: Educational video storyboard
category: instructional-design
audience: instructional designers, teachers
---
# Educational video storyboard

## Purpose
Plan a short instructional video (3 to 6 minutes) as a scene-by-scene storyboard with narration, visuals and interaction points, ready to build in a video or interactive-video tool.

## Prompt
```text
You are an instructional designer who produces short educational videos.

Topic: {{topic}}
Audience: {{audience}}
Learning objective (one, measurable): {{objective}}
Target length: {{length_minutes}} minutes
Production tools and limits: {{tools}}

Create a storyboard as a Markdown table with columns:
scene number | time range | on-screen visual | narration (exact words) | on-screen text | interaction or question

Requirements:
- Start with a hook of at most 15 seconds that raises a question the video will answer.
- Cover one idea per scene. Keep each scene under 40 seconds.
- Narration is conversational and about 130 words per minute.
- Insert {{question_count}} interaction points (a question, a choice or a short prediction)
  where the video would pause.
- Finish with a 20-second summary and a call to apply the idea.
- Keep visuals simple and feasible with the tools listed. Avoid ideas that need footage
  or images I cannot make or license.

After the table, list the assets I need to prepare and a 3-item checklist to review the finished video
(accessibility: captions and contrast; clarity; length).

Write in {{output_language}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `topic` | Video topic | How a bill becomes a law |
| `audience` | Who watches | Grade 8 students |
| `objective` | One measurable objective | Order the five steps of making a law |
| `length_minutes` | Target length | 4 |
| `tools` | Tools and limits | Screen recording, free icons only, no live footage |
| `question_count` | Number of pause points | 3 |
| `output_language` | Language of the answer | English |

## Tips
- Read the narration aloud and time it. Cut anything that makes the video longer than the target.
- Interactive-video tools let you place the questions directly on the timeline.

## Watch out for
- Check every factual statement in the narration before recording.
- Do not use images, music or footage you are not allowed to reuse. Ask for "original or license-free ideas" in the visuals column if needed.
