import copy

import pytest

from lesson_plan_assistant import LessonRequest, validate_plan
from lesson_plan_assistant.prompt import build_user_prompt


def test_valid_plan_has_no_problems(good_plan, req):
    assert validate_plan(good_plan, req) == []


def test_non_object_is_rejected(req):
    assert validate_plan(["not", "a", "dict"], req) == ["The answer must be a JSON object."]


def test_minutes_must_add_up_to_duration(good_plan, req):
    good_plan["activities"][0]["minutes"] = 10
    problems = validate_plan(good_plan, req)
    assert any("add up to 45" in p for p in problems)


def test_wrong_number_of_objectives(good_plan, req):
    good_plan["objectives"].pop()
    assert any("exactly 3" in p for p in validate_plan(good_plan, req))


def test_needs_two_differentiation_ideas(good_plan, req):
    good_plan["differentiation"] = ["only one"]
    assert any("differentiation" in p for p in validate_plan(good_plan, req))


@pytest.mark.parametrize("key", ["title", "objectives", "materials", "activities", "assessment", "homework"])
def test_missing_keys_are_reported(good_plan, req, key):
    broken = copy.deepcopy(good_plan)
    del broken[key]
    assert validate_plan(broken, req)


def test_bool_is_not_accepted_as_minutes(good_plan, req):
    good_plan["activities"][0]["minutes"] = True
    assert any("Activity 1" in p for p in validate_plan(good_plan, req))


def test_prompt_states_all_constraints(req):
    prompt = build_user_prompt(req)
    assert "Mathematics" in prompt and "Fractions" in prompt and "grade 5" in prompt
    assert "exactly 40 minutes" in prompt
    assert "exactly 3 measurable" in prompt
    assert "in English" in prompt


def test_prompt_includes_teacher_notes():
    r = LessonRequest("Science", "Plants", 3, notes="Class of 28, no projector")
    assert "Class of 28, no projector" in build_user_prompt(r)


@pytest.mark.parametrize("kwargs", [
    {"grade": 0}, {"grade": 13}, {"duration_min": 5}, {"num_objectives": 0}, {"language": "fr"}, {"topic": " "},
])
def test_request_validation(kwargs):
    base = dict(subject="Math", topic="Fractions", grade=5)
    base.update(kwargs)
    with pytest.raises(ValueError):
        LessonRequest(**base)
