"""Generate a lesson plan with a Claude model and validate the result.

The Anthropic SDK is imported lazily, so everything else (prompting, validation,
rendering, tests with a fake client) works without it or without an API key.
"""
from __future__ import annotations

import json
import os
import re
from typing import Any, Protocol

from .models import LessonRequest
from .prompt import SYSTEM_PROMPT, build_repair_prompt, build_user_prompt
from .schema import validate_plan

DEFAULT_MODEL = "claude-sonnet-5-5"
MAX_TOKENS = 2000


class PlanError(RuntimeError):
    """Raised when no valid plan could be produced."""


class MessagesClient(Protocol):
    """The small part of the Anthropic client this module relies on."""

    messages: Any


def extract_json(text: str) -> Any:
    """Parse the first JSON object in `text`, tolerating Markdown code fences."""
    cleaned = re.sub(r"^```(?:json)?\s*|\s*```$", "", text.strip(), flags=re.IGNORECASE)
    start, end = cleaned.find("{"), cleaned.rfind("}")
    if start == -1 or end <= start:
        raise ValueError("no JSON object found in the model answer")
    return json.loads(cleaned[start : end + 1])


def _answer_text(response: Any) -> str:
    return "".join(
        block.text for block in response.content if getattr(block, "type", "text") == "text"
    )


def make_client() -> MessagesClient:
    if not os.environ.get("ANTHROPIC_API_KEY"):
        raise PlanError("Set the ANTHROPIC_API_KEY environment variable (or use --dry-run).")
    import anthropic  # lazy import

    return anthropic.Anthropic()


def generate_plan(
    req: LessonRequest,
    client: MessagesClient | None = None,
    model: str | None = None,
    max_repairs: int = 1,
) -> dict[str, Any]:
    """Ask the model for a plan; if validation fails, send the problems back once."""
    client = client or make_client()
    model = model or os.environ.get("ANTHROPIC_MODEL", DEFAULT_MODEL)

    messages: list[dict[str, str]] = [{"role": "user", "content": build_user_prompt(req)}]
    problems: list[str] = []

    for attempt in range(max_repairs + 1):
        response = client.messages.create(
            model=model, max_tokens=MAX_TOKENS, system=SYSTEM_PROMPT, messages=messages
        )
        text = _answer_text(response)
        try:
            plan = extract_json(text)
        except ValueError as exc:  # JSONDecodeError is a ValueError
            problems = [f"The answer was not valid JSON ({exc})."]
        else:
            problems = validate_plan(plan, req)
            if not problems:
                return plan
        if attempt < max_repairs:
            messages += [
                {"role": "assistant", "content": text},
                {"role": "user", "content": build_repair_prompt(problems)},
            ]

    raise PlanError("No valid plan after repair: " + " ".join(problems))
