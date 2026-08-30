from __future__ import annotations

from pydantic import BaseModel, Field


class ActivityIngestionRequest(BaseModel):
    """
    Request model for dynamically creating
    and analyzing a new enterprise activity.
    """

    process_id: int = Field(
        ...,
        gt=0,
        description="Existing process ID for the new activity.",
    )

    name: str = Field(
        ...,
        min_length=1,
        max_length=200,
        description="Name of the new activity.",
    )

    description: str = Field(
        ...,
        min_length=1,
        max_length=5000,
        description="Description of the new activity.",
    )

    activity_type: str | None = Field(
        default=None,
        max_length=50,
        description="Optional activity type. AI classification will determine it if omitted.",
    )