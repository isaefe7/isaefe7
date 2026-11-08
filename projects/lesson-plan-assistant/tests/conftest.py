import json
from types import SimpleNamespace

import pytest

from lesson_plan_assistant import LessonRequest


@pytest.fixture
def req() -> LessonRequest:
    return LessonRequest(subject="Mathematics", topic="Fractions", grade=5, duration_min=40,
                         num_objectives=3, language="en")


@pytest.fixture
def good_plan() -> dict:
    return {
        "title": "Introduction to Fractions",
        "grade": 5,
        "duration_minutes": 40,
        "objectives": ["Define a fraction", "Compare two fractions", "Shade a fraction of a shape"],
        "materials": ["Paper strips", "Markers"],
        "activities": [
            {"name": "Warm-up", "minutes": 5, "description": "Share a pizza between friends."},
            {"name": "Paper folding", "minutes": 20, "description": "Fold strips into halves and quarters."},
            {"name": "Pair practice", "minutes": 10, "description": "Compare fractions in pairs."},
            {"name": "Exit ticket", "minutes": 5, "description": "Write one fraction you made."},
        ],
        "assessment": ["Exit ticket with two questions"],
        "differentiation": ["Pre-folded strips for learners who need support", "Ask advanced learners for equivalent fractions"],
        "homework": "Find three fractions at home.",
    }


class FakeClient:
    """Mimics `anthropic.Anthropic().messages.create` and records the calls."""

    def __init__(self, *answers: str):
        self.answers = list(answers)
        self.calls: list[dict] = []
        self.messages = SimpleNamespace(create=self._create)

    def _create(self, **kwargs):
        self.calls.append(kwargs)
        text = self.answers.pop(0)
        return SimpleNamespace(content=[SimpleNamespace(type="text", text=text)])


def as_json(plan: dict) -> str:
    return json.dumps(plan)
