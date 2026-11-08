"""Render a validated plan as Markdown."""
from __future__ import annotations

from typing import Any


def to_markdown(plan: dict[str, Any]) -> str:
    out = [
        f"# {plan['title']}",
        "",
        f"**Grade:** {plan['grade']} · **Duration:** {plan['duration_minutes']} min",
        "",
        "## Objectives",
        *[f"{i}. {o}" for i, o in enumerate(plan["objectives"], start=1)],
        "",
        "## Materials",
        *[f"- {m}" for m in plan["materials"]],
        "",
        "## Activities",
        "",
        "| # | Activity | Minutes | Description |",
        "|---|---|---|---|",
    ]
    for i, act in enumerate(plan["activities"], start=1):
        description = act["description"].replace("|", "\\|").replace("\n", " ")
        out.append(f"| {i} | {act['name']} | {act['minutes']} | {description} |")
    out += [
        "",
        "## Assessment",
        *[f"- {a}" for a in plan["assessment"]],
        "",
        "## Differentiation",
        *[f"- {d}" for d in plan["differentiation"]],
    ]
    if plan.get("homework", "").strip():
        out += ["", "## Homework", plan["homework"].strip()]
    return "\n".join(out) + "\n"
