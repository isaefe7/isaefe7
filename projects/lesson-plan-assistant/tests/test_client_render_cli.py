import pytest

from conftest import FakeClient, as_json
from lesson_plan_assistant import PlanError, generate_plan, to_markdown
from lesson_plan_assistant.cli import main
from lesson_plan_assistant.client import extract_json


def test_extract_json_handles_code_fences():
    assert extract_json('```json\n{"a": 1}\n```') == {"a": 1}
    assert extract_json('Here you go: {"a": 1} Hope it helps') == {"a": 1}


def test_extract_json_without_object_raises():
    with pytest.raises(ValueError):
        extract_json("no json here")


def test_generate_plan_returns_valid_plan(req, good_plan):
    client = FakeClient(as_json(good_plan))
    plan = generate_plan(req, client=client, model="test-model")
    assert plan == good_plan
    call = client.calls[0]
    assert call["model"] == "test-model"
    assert "JSON" in call["system"]
    assert call["messages"][0]["role"] == "user"


def test_invalid_plan_is_repaired_once(req, good_plan):
    bad = dict(good_plan, activities=[dict(a) for a in good_plan["activities"]])
    bad["activities"][0]["minutes"] = 1
    client = FakeClient(as_json(bad), as_json(good_plan))
    assert generate_plan(req, client=client, model="m") == good_plan
    assert len(client.calls) == 2
    repair_request = client.calls[1]["messages"][-1]["content"]
    assert "add up to" in repair_request
    assert [m["role"] for m in client.calls[1]["messages"]] == ["user", "assistant", "user"]


def test_malformed_json_is_repaired(req, good_plan):
    client = FakeClient("Sorry, I cannot do that", as_json(good_plan))
    assert generate_plan(req, client=client, model="m") == good_plan


def test_gives_up_after_max_repairs(req):
    client = FakeClient("nope", "still nope")
    with pytest.raises(PlanError):
        generate_plan(req, client=client, model="m", max_repairs=1)
    assert len(client.calls) == 2


def test_missing_api_key_gives_clear_error(req, monkeypatch):
    monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
    with pytest.raises(PlanError, match="ANTHROPIC_API_KEY"):
        generate_plan(req)


def test_markdown_contains_all_sections(good_plan):
    md = to_markdown(good_plan)
    for heading in ["# Introduction to Fractions", "## Objectives", "## Materials",
                    "## Activities", "## Assessment", "## Differentiation", "## Homework"]:
        assert heading in md
    assert "| 2 | Paper folding | 20 |" in md


def test_markdown_escapes_table_pipes(good_plan):
    good_plan["activities"][0]["description"] = "a | b\nsecond line"
    assert "a \\| b second line" in to_markdown(good_plan)


def test_cli_dry_run_makes_no_api_call(capsys, monkeypatch):
    monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
    code = main(["Fractions", "--subject", "Mathematics", "--grade", "5", "--dry-run"])
    out = capsys.readouterr().out
    assert code == 0 and "=== SYSTEM ===" in out and "Fractions" in out


def test_cli_rejects_invalid_input(capsys):
    assert main(["Fractions", "--subject", "Math", "--grade", "99", "--dry-run"]) == 2
    assert "grade" in capsys.readouterr().err
