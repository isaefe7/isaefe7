"""Command-line interface: python -m lesson_plan_assistant ..."""
from __future__ import annotations

import argparse
import sys

from .client import PlanError, generate_plan
from .models import LANGUAGES, LessonRequest
from .prompt import SYSTEM_PROMPT, build_user_prompt
from .render import to_markdown


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="lesson-plan-assistant",
        description="Generate a validated lesson plan with a Claude model.",
    )
    p.add_argument("topic", help="lesson topic, e.g. 'Fractions'")
    p.add_argument("--subject", required=True, help="subject, e.g. 'Mathematics'")
    p.add_argument("--grade", type=int, required=True, help="grade level, 1-12")
    p.add_argument("--duration", type=int, default=40, help="lesson length in minutes (default 40)")
    p.add_argument("--objectives", type=int, default=3, help="number of objectives (default 3)")
    p.add_argument("--lang", choices=sorted(LANGUAGES), default="tr", help="output language (default tr)")
    p.add_argument("--notes", default="", help="extra notes for the model, e.g. class size or available tools")
    p.add_argument("--model", default=None, help="override the model (or set ANTHROPIC_MODEL)")
    p.add_argument("--out", default=None, help="write the Markdown plan to this file")
    p.add_argument("--dry-run", action="store_true", help="print the prompt and exit without calling the API")
    return p


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    try:
        req = LessonRequest(
            subject=args.subject, topic=args.topic, grade=args.grade,
            duration_min=args.duration, num_objectives=args.objectives,
            language=args.lang, notes=args.notes,
        )
    except ValueError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 2

    if args.dry_run:
        print("=== SYSTEM ===\n" + SYSTEM_PROMPT + "\n\n=== USER ===\n" + build_user_prompt(req))
        return 0

    try:
        markdown = to_markdown(generate_plan(req, model=args.model))
    except PlanError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1

    if args.out:
        with open(args.out, "w", encoding="utf-8") as fh:
            fh.write(markdown)
        print(f"Saved to {args.out}")
    else:
        print(markdown)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
