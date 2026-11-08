"""Data model for a lesson plan request."""
from __future__ import annotations

from dataclasses import dataclass

LANGUAGES = {"tr": "Turkish", "en": "English"}


@dataclass(frozen=True)
class LessonRequest:
    subject: str
    topic: str
    grade: int
    duration_min: int = 40
    num_objectives: int = 3
    language: str = "tr"
    notes: str = ""

    def __post_init__(self) -> None:
        if not self.subject.strip() or not self.topic.strip():
            raise ValueError("subject and topic must not be empty")
        if not 1 <= self.grade <= 12:
            raise ValueError("grade must be between 1 and 12")
        if not 10 <= self.duration_min <= 180:
            raise ValueError("duration_min must be between 10 and 180")
        if not 1 <= self.num_objectives <= 6:
            raise ValueError("num_objectives must be between 1 and 6")
        if self.language not in LANGUAGES:
            raise ValueError(f"language must be one of {sorted(LANGUAGES)}")

    @property
    def language_name(self) -> str:
        return LANGUAGES[self.language]
