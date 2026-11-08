"""Lesson plan assistant: prompt, call, validate, render."""
from .client import PlanError, generate_plan
from .models import LessonRequest
from .render import to_markdown
from .schema import validate_plan

__all__ = ["LessonRequest", "PlanError", "generate_plan", "to_markdown", "validate_plan"]
__version__ = "0.1.0"
