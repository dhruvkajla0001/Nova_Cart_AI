from __future__ import annotations

import re
from typing import Any


class ActivityExtractor:
    """
    Deterministic normalization and validation layer
    for runtime activity ingestion.
    """

    MAX_NAME_LENGTH = 200
    MAX_DESCRIPTION_LENGTH = 5000

    @staticmethod
    def _clean(value: Any) -> str:
        if value is None:
            return ""

        return re.sub(
            r"\s+",
            " ",
            str(value),
        ).strip()

    @classmethod
    def extract(
        cls,
        payload: dict[str, Any],
    ) -> dict[str, Any]:

        name = cls._clean(
            payload.get("name")
        )

        description = cls._clean(
            payload.get("description")
        )

        activity_type = cls._clean(
            payload.get("activity_type")
        ).upper()

        process_id = payload.get(
            "process_id"
        )

        if not name:
            raise ValueError(
                "Activity name is required."
            )

        if len(name) > cls.MAX_NAME_LENGTH:
            raise ValueError(
                "Activity name exceeds 200 characters."
            )

        if len(description) > cls.MAX_DESCRIPTION_LENGTH:
            raise ValueError(
                "Activity description exceeds 5000 characters."
            )

        if process_id is None:
            raise ValueError(
                "process_id is required."
            )

        try:
            process_id = int(process_id)
        except (TypeError, ValueError) as exc:
            raise ValueError(
                "process_id must be an integer."
            ) from exc

        if process_id <= 0:
            raise ValueError(
                "process_id must be greater than zero."
            )

        return {
            "process_id": process_id,
            "name": name,
            "description": description,
            "activity_type": activity_type or None,
        }