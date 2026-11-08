import importlib.util
import sys
from pathlib import Path

import pytest

SCRIPT = Path(__file__).resolve().parent.parent / "scripts" / "check_prompts.py"
spec = importlib.util.spec_from_file_location("check_prompts", SCRIPT)
cp = importlib.util.module_from_spec(spec)
sys.modules["check_prompts"] = cp
spec.loader.exec_module(cp)

GOOD = """---
title: Demo
category: demo
audience: teachers
---
# Demo

## Purpose
Something.

## Prompt
```text
Teach {{topic}} to grade {{grade}}.
```

## Variables
| Variable | Description | Example |
|---|---|---|
| `topic` | The topic | Fractions |
| `grade` | The grade | 5 |

## Tips
- a tip

## Watch out for
- a warning
"""


def write(tmp_path, text, folder="demo"):
    d = tmp_path / folder
    d.mkdir(exist_ok=True)
    p = d / "p.md"
    p.write_text(text, encoding="utf-8")
    return p


def test_real_library_is_valid():
    files = cp.collect()
    assert len(files) >= 8
    bad = {str(f.path.name): f.problems for f in files if f.problems}
    assert bad == {}


def test_good_file_passes(tmp_path):
    assert cp.check_file(write(tmp_path, GOOD)).problems == []


def test_unlisted_variable_is_reported(tmp_path):
    text = GOOD.replace("| `grade` | The grade | 5 |\n", "")
    assert any("`grade` is used" in p for p in cp.check_file(write(tmp_path, text)).problems)


def test_unused_variable_is_reported(tmp_path):
    text = GOOD.replace("Teach {{topic}} to grade {{grade}}.", "Teach {{topic}}.")
    assert any("never used" in p for p in cp.check_file(write(tmp_path, text)).problems)


def test_category_must_match_folder(tmp_path):
    problems = cp.check_file(write(tmp_path, GOOD, folder="other")).problems
    assert any("does not match folder" in p for p in problems)


def test_missing_section_is_reported(tmp_path):
    text = GOOD.replace("## Tips\n- a tip\n\n", "")
    assert any("## Tips" in p for p in cp.check_file(write(tmp_path, text)).problems)


def test_malformed_placeholder(tmp_path):
    text = GOOD.replace("{{topic}}", "{{Topic Name}}", 1)
    assert any("malformed" in p for p in cp.check_file(write(tmp_path, text)).problems)


def test_missing_front_matter(tmp_path):
    text = GOOD.split("---\n", 2)[2]
    assert any("front matter" in p for p in cp.check_file(write(tmp_path, text)).problems)


def test_two_prompt_blocks_rejected(tmp_path):
    text = GOOD.replace("```\n\n## Variables", "```\n```text\nmore\n```\n\n## Variables")
    assert any("exactly one" in p for p in cp.check_file(write(tmp_path, text)).problems)
