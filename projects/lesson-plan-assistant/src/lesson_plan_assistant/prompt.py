"""Prompt construction.

Design choices (see README):
* a short system prompt fixes the role and the output contract;
* the user prompt states every constraint explicitly (grade, duration, counts);
* the model must answer with a single JSON object, so the result can be validated
  by code instead of being trusted.
"""
from __future__ import annotations

from .models import LessonRequest

SYSTEM_PROMPT = (
    "You are an experienced curriculum designer who helps school teachers prepare "
    "lesson plans. You write practical, age-appropriate plans that a teacher can use "
    "tomorrow. You never invent statistics or cite sources you are not sure about. "
    "You answer with one JSON object and nothing else."
)

JSON_SHAPE = """{
  "title": "string",
  "grade": integer,
  "duration_minutes": integer,
  "objectives": ["string", ...],
  "materials": ["string", ...],
  "activities": [
    {"name": "string", "minutes": integer, "description": "string"}
  ],
  "assessment": ["string", ...],
  "differentiation": ["string", ...],
  "homework": "string"
}"""


def build_user_prompt(req: LessonRequest) -> str:
    lines = [
        f"Create a lesson plan for the subject \"{req.subject}\", topic \"{req.topic}\", "
        f"for grade {req.grade}.",
        "",
        "Hard constraints:",
        f"- Write all text values in {req.language_name}.",
        f"- The lesson lasts exactly {req.duration_min} minutes: the `minutes` of all "
        f"activities must add up to {req.duration_min}.",
        f"- Provide exactly {req.num_objectives} measurable learning objectives "
        "(start each with an action verb).",
        "- Provide 3 to 6 activities in a sensible order (introduction, main work, closing).",
        "- Provide at least one assessment idea and at least two differentiation ideas "
        "(support for struggling learners and extension for advanced learners).",
    ]
    if req.notes.strip():
        lines += ["", f"Teacher's notes: {req.notes.strip()}"]
    lines += [
        "",
        "Return only a JSON object with exactly this shape (no Markdown, no comments):",
        JSON_SHAPE,
    ]
    return "\n".join(lines)


def build_repair_prompt(problems: list[str]) -> str:
    bullet_list = "\n".join(f"- {p}" for p in problems)
    return (
        "Your previous answer did not meet the requirements:\n"
        f"{bullet_list}\n\n"
        "Return the corrected lesson plan as a single JSON object with the same shape."
    )
