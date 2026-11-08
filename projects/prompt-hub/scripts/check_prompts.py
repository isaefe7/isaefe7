#!/usr/bin/env python3
"""Validate the prompt library and keep the README index up to date.

    python scripts/check_prompts.py                # validate, exit code 1 on problems
    python scripts/check_prompts.py --write-index  # also rewrite the table in README.md

A prompt file is valid when:
  * it has front matter with `title`, `category` and `audience`, and `category`
    matches the folder it lives in;
  * it has the sections Purpose, Prompt, Variables, Tips and "Watch out for";
  * the Prompt section contains exactly one ```text block;
  * every {{variable}} used in that block is listed in the Variables table, and
    every listed variable is used (so templates never carry dead placeholders);
  * no {{variable}} name is malformed (lowercase letters, digits and underscores).
Standard library only.
"""
from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PROMPTS = ROOT / "prompts"
REQUIRED_FRONT = ("title", "category", "audience")
REQUIRED_SECTIONS = ("Purpose", "Prompt", "Variables", "Tips", "Watch out for")
PLACEHOLDER = re.compile(r"\{\{\s*([^{}]*?)\s*\}\}")
VALID_NAME = re.compile(r"^[a-z][a-z0-9_]*$")


@dataclass
class PromptFile:
    path: Path
    front: dict[str, str] = field(default_factory=dict)
    problems: list[str] = field(default_factory=list)


def parse_front_matter(text: str) -> tuple[dict[str, str], str]:
    match = re.match(r"^---\n(.*?)\n---\n", text, flags=re.S)
    if not match:
        return {}, text
    front = {}
    for line in match.group(1).splitlines():
        if ":" in line:
            key, value = line.split(":", 1)
            front[key.strip()] = value.strip()
    return front, text[match.end():]


def sections(body: str) -> dict[str, str]:
    parts = re.split(r"^## (.+)$", body, flags=re.M)
    return {parts[i].strip(): parts[i + 1] for i in range(1, len(parts) - 1, 2)}


def table_variables(section: str) -> list[str]:
    names = []
    for line in section.splitlines():
        cell = line.strip().strip("|").split("|")[0].strip()
        m = re.fullmatch(r"`([^`]+)`", cell)
        if m:
            names.append(m.group(1))
    return names


def check_file(path: Path) -> PromptFile:
    result = PromptFile(path)
    text = path.read_text(encoding="utf-8")
    front, body = parse_front_matter(text)
    result.front = front

    for key in REQUIRED_FRONT:
        if not front.get(key):
            result.problems.append(f"front matter is missing `{key}`")
    if front.get("category") and front["category"] != path.parent.name:
        result.problems.append(
            f"category `{front['category']}` does not match folder `{path.parent.name}`"
        )

    secs = sections(body)
    for name in REQUIRED_SECTIONS:
        if name not in secs:
            result.problems.append(f"missing section `## {name}`")
    if "Prompt" not in secs or "Variables" not in secs:
        return result

    blocks = re.findall(r"```text\n(.*?)```", secs["Prompt"], flags=re.S)
    if len(blocks) != 1:
        result.problems.append(f"Prompt section must contain exactly one ```text block (found {len(blocks)})")
        return result

    used = [m.group(1) for m in PLACEHOLDER.finditer(blocks[0])]
    for name in used:
        if not VALID_NAME.match(name):
            result.problems.append(f"malformed placeholder `{{{{{name}}}}}`")
    listed = table_variables(secs["Variables"])
    for name in sorted(set(used) - set(listed)):
        result.problems.append(f"`{name}` is used in the prompt but not listed under Variables")
    for name in sorted(set(listed) - set(used)):
        result.problems.append(f"`{name}` is listed under Variables but never used in the prompt")
    if len(listed) != len(set(listed)):
        result.problems.append("duplicate rows in the Variables table")
    return result


def collect() -> list[PromptFile]:
    return [check_file(p) for p in sorted(PROMPTS.rglob("*.md"))]


def index_table(files: list[PromptFile]) -> str:
    rows = ["| Category | Prompt | Variables |", "|---|---|---|"]
    for f in files:
        rel = f.path.relative_to(ROOT).as_posix()
        text = f.path.read_text(encoding="utf-8")
        _, body = parse_front_matter(text)
        block = re.search(r"```text\n(.*?)```", sections(body).get("Prompt", ""), flags=re.S)
        n = len(set(PLACEHOLDER.findall(block.group(1)))) if block else 0
        rows.append(f"| {f.front.get('category', '?')} | [{f.front.get('title', f.path.stem)}]({rel}) | {n} |")
    return "\n".join(rows)


def write_index(files: list[PromptFile]) -> None:
    readme = ROOT / "README.md"
    text = readme.read_text(encoding="utf-8")
    start, end = "<!-- INDEX:START -->", "<!-- INDEX:END -->"
    if start not in text or end not in text:
        raise SystemExit("README.md has no INDEX markers")
    head, rest = text.split(start, 1)
    _, tail = rest.split(end, 1)
    readme.write_text(f"{head}{start}\n{index_table(files)}\n{end}{tail}", encoding="utf-8")


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--write-index", action="store_true", help="update the prompt table in README.md")
    args = ap.parse_args(argv)

    files = collect()
    failed = 0
    for f in files:
        for p in f.problems:
            print(f"{f.path.relative_to(ROOT)}: {p}")
        failed += bool(f.problems)
    print(f"{len(files)} prompts checked, {failed} with problems")
    if args.write_index and not failed:
        write_index(files)
        print("README index updated")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
