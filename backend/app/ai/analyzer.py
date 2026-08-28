from __future__ import annotations

from typing import Any


class AIAnalyzer:
    """
    Analyzes an enterprise activity for AI automation
    and augmentation potential.

    This layer combines:
        - activity characteristics
        - activity classification
        - existing AI opportunity data
        - role/skill context

    The LLM reasoning layer will be added separately.
    """

    # Baseline scores by type of work.
    # These are starting points, not final AI decisions.
    CATEGORY_BASELINES = {
        "ANALYSIS": {
            "automation": 75.0,
            "augmentation": 90.0,
        },
        "DECISION": {
            "automation": 45.0,
            "augmentation": 90.0,
        },
        "CONTENT": {
            "automation": 80.0,
            "augmentation": 95.0,
        },
        "CUSTOMER_INTERACTION": {
            "automation": 55.0,
            "augmentation": 90.0,
        },
        "PLANNING": {
            "automation": 50.0,
            "augmentation": 88.0,
        },
        "OPERATIONS": {
            "automation": 55.0,
            "augmentation": 85.0,
        },
        "PHYSICAL_OPERATION": {
            "automation": 30.0,
            "augmentation": 80.0,
        },
        "ADMINISTRATION": {
            "automation": 85.0,
            "augmentation": 90.0,
        },
        "FINANCIAL": {
            "automation": 70.0,
            "augmentation": 90.0,
        },
        "RISK_COMPLIANCE": {
            "automation": 55.0,
            "augmentation": 90.0,
        },
        "TECHNICAL": {
            "automation": 60.0,
            "augmentation": 90.0,
        },
        "OTHER": {
            "automation": 40.0,
            "augmentation": 70.0,
        },
    }

    @staticmethod
    def _clamp(
        value: float,
        minimum: float = 0.0,
        maximum: float = 100.0,
    ) -> float:
        return round(
            max(minimum, min(maximum, value)),
            2,
        )

    @classmethod
    def analyze(
        cls,
        activity: dict[str, Any],
        classification: dict[str, Any],
        opportunities: list[dict[str, Any]] | None = None,
        roles: list[dict[str, Any]] | None = None,
        skills: list[dict[str, Any]] | None = None,
    ) -> dict[str, Any]:
        """
        Generate an AI assessment for an activity.
        """

        opportunities = opportunities or []
        roles = roles or []
        skills = skills or []

        category = classification.get(
            "category",
            "OTHER",
        )

        baseline = cls.CATEGORY_BASELINES.get(
            category,
            cls.CATEGORY_BASELINES["OTHER"],
        )

        automation_score = baseline["automation"]
        augmentation_score = baseline["augmentation"]

        # --------------------------------------------------------
        # Use existing database intelligence when available.
        # --------------------------------------------------------

        if opportunities:

            opportunity_automation = [
                float(
                    item["automation_score"]
                )
                for item in opportunities
                if item.get("automation_score") is not None
            ]

            opportunity_augmentation = [
                float(
                    item["augmentation_score"]
                )
                for item in opportunities
                if item.get("augmentation_score") is not None
            ]

            if opportunity_automation:
                automation_score = (
                    sum(opportunity_automation)
                    / len(opportunity_automation)
                )

            if opportunity_augmentation:
                augmentation_score = (
                    sum(opportunity_augmentation)
                    / len(opportunity_augmentation)
                )

        # --------------------------------------------------------
        # Physical work should generally favor augmentation.
        # --------------------------------------------------------

        if category == "PHYSICAL_OPERATION":
            automation_score = min(
                automation_score,
                45.0,
            )

            augmentation_score = max(
                augmentation_score,
                75.0,
            )

        # --------------------------------------------------------
        # More contextual graph information increases confidence.
        # --------------------------------------------------------

        confidence = 0.65

        if activity.get("description"):
            confidence += 0.05

        if classification.get("confidence"):
            confidence += (
                float(
                    classification["confidence"]
                )
                - 0.5
            ) * 0.20

        if opportunities:
            confidence += 0.10

        if roles:
            confidence += 0.05

        if skills:
            confidence += 0.05

        confidence = min(
            0.98,
            confidence,
        )

        # --------------------------------------------------------
        # Determine dominant AI mode.
        # --------------------------------------------------------

        if automation_score >= 70:
            ai_mode = "HIGH_AUTOMATION"

        elif automation_score >= 45:
            ai_mode = "PARTIAL_AUTOMATION"

        else:
            ai_mode = "AUGMENTATION"

        # --------------------------------------------------------
        # Extract technologies from known opportunities.
        # --------------------------------------------------------

        technologies = sorted(
            {
                item["technology"]
                for item in opportunities
                if item.get("technology")
            }
        )

        # --------------------------------------------------------
        # Identify strongest AI opportunity.
        # --------------------------------------------------------

        primary_opportunity = None

        if opportunities:

            primary_opportunity = max(
                opportunities,
                key=lambda item: (
                    float(
                        item.get(
                            "confidence_score",
                            0,
                        ) or 0
                    ),
                    float(
                        item.get(
                            "automation_score",
                            0,
                        ) or 0
                    ),
                ),
            )

        return {
            "activity": {
                "activity_id": activity.get(
                    "activity_id"
                ),
                "activity_code": activity.get(
                    "activity_code"
                ),
                "name": activity.get(
                    "name"
                ),
                "activity_type": activity.get(
                    "activity_type"
                ),
            },

            "classification": {
                "category": category,
                "confidence": classification.get(
                    "confidence"
                ),
            },

            "ai_assessment": {
                "automation_score": cls._clamp(
                    automation_score
                ),
                "augmentation_score": cls._clamp(
                    augmentation_score
                ),
                "ai_mode": ai_mode,
                "confidence": round(
                    confidence,
                    2,
                ),
            },

            "ai_opportunity": (
                {
                    "ai_opportunity_id":
                        primary_opportunity.get(
                            "ai_opportunity_id"
                        ),
                    "name":
                        primary_opportunity.get(
                            "name"
                        ),
                    "ai_type":
                        primary_opportunity.get(
                            "ai_type"
                        ),
                    "technology":
                        primary_opportunity.get(
                            "technology"
                        ),
                }
                if primary_opportunity
                else None
            ),

            "technologies": technologies,

            "context": {
                "role_count": len(roles),
                "skill_count": len(skills),
                "opportunity_count": len(
                    opportunities
                ),
            },
        }