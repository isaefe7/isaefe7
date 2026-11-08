"""Deterministic checks on a generated lesson plan.

Returning a list of problems (instead of raising) lets the client feed them back
to the model for one repair attempt, and lets the same function be used as a tiny
evaluation of any plan, however it was produced.
"""
from __future__ import annotations

from typing import Any

from .models import LessonRequest


def _is_str_list(value: Any, minimum: int = 1) -> bool:
    return (
        isinstance(value, list)
        and len(value) >= minimum
        and all(isinstance(v, str) and v.strip() for v in value)
    )


def validate_plan(plan: Any, req: LessonRequest) -> list[str]:
    """Return a list of human-readable problems; an empty list means the plan is valid."""
    if not isinstance(plan, dict):
        return ["The answer must be a JSON object."]

    problems: list[str] = []

    if not isinstance(plan.get("title"), str) or not plan["title"].strip():
        problems.append("`title` must be a non-empty string.")
    if plan.get("grade") != req.grade:
        problems.append(f"`grade` must be {req.grade}.")
    if plan.get("duration_minutes") != req.duration_min:
        problems.append(f"`duration_minutes` must be {req.duration_min}.")

    objectives = plan.get("objectives")
    if not _is_str_list(objectives):
        problems.append("`objectives` must be a non-empty list of strings.")
    elif len(objectives) != req.num_objectives:
        problems.append(f"`objectives` must contain exactly {req.num_objectives} items.")

    if not _is_str_list(plan.get("materials")):
        problems.append("`materials` must be a non-empty list of strings.")
    if not _is_str_list(plan.get("assessment")):
        problems.append("`assessment` must be a non-empty list of strings.")
    if not _is_str_list(plan.get("differentiation"), minimum=2):
        problems.append("`differentiation` must contain at least two strings.")
    if not isinstance(plan.get("homework"), str):
        problems.append("`homework` must be a string (use an empty string if none).")

    activities = plan.get("activities")
    if not isinstance(activities, list) or not 3 <= len(activities) <= 6:
        problems.append("`activities` must be a list of 3 to 6 items.")
    else:
        total = 0
        for i, act in enumerate(activities, start=1):
            ok = (
                isinstance(act, dict)
                and isinstance(act.get("name"), str) and act["name"].strip()
                and isinstance(act.get("description"), str) and act["description"].strip()
                and isinstance(act.get("minutes"), int) and not isinstance(act["minutes"], bool)
                and act["minutes"] > 0
            )
            if not ok:
                problems.append(
                    f"Activity {i} needs a `name`, a `description` and a positive integer `minutes`."
                )
            else:
                total += act["minutes"]
        if not problems and total != req.duration_min:
            problems.append(
                f"Activity minutes add up to {total}, but the lesson lasts {req.duration_min}."
            )

    return problems
