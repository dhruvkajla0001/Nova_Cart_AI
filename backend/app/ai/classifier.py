from __future__ import annotations

from typing import Any


class ActivityClassifier:
    """
    Classifies enterprise activities into broad work categories.

    The classifier is intentionally deterministic.
    Runtime LLM reasoning will be added in the analyzer/reasoning layer.
    """

    CATEGORIES = (
        "ANALYSIS",
        "DECISION",
        "CONTENT",
        "CUSTOMER_INTERACTION",
        "PLANNING",
        "OPERATIONS",
        "PHYSICAL_OPERATION",
        "ADMINISTRATION",
        "FINANCIAL",
        "RISK_COMPLIANCE",
        "TECHNICAL",
        "OTHER",
    )

    KEYWORDS = {
        "PHYSICAL_OPERATION": (
            "pick",
            "pack",
            "load",
            "unload",
            "warehouse",
            "deliver",
            "sort",
            "move",
            "handle",
            "inspect physical",
        ),
        "ANALYSIS": (
            "analyze",
            "analysis",
            "score",
            "evaluate",
            "monitor",
            "track",
            "forecast",
            "measure",
            "assess",
            "review",
        ),
        "DECISION": (
            "decide",
            "decision",
            "approve",
            "select",
            "prioritize",
            "allocate",
            "recommend",
            "optimize",
        ),
        "CONTENT": (
            "create content",
            "write",
            "design",
            "publish",
            "copy",
            "campaign content",
            "generate content",
        ),
        "CUSTOMER_INTERACTION": (
            "customer support",
            "customer service",
            "respond",
            "resolve customer",
            "assist customer",
            "communicate with customer",
        ),
        "PLANNING": (
            "plan",
            "planning",
            "strategy",
            "strategic",
            "budget",
            "roadmap",
            "objectives",
        ),
        "FINANCIAL": (
            "payment",
            "refund",
            "reconciliation",
            "invoice",
            "pricing",
            "financial",
            "fraud",
        ),
        "RISK_COMPLIANCE": (
            "risk",
            "compliance",
            "audit",
            "governance",
            "fraud detection",
        ),
        "TECHNICAL": (
            "model",
            "data pipeline",
            "software",
            "technical",
            "machine learning",
            "engineering",
        ),
        "ADMINISTRATION": (
            "administration",
            "administrative",
            "documentation",
            "record",
            "schedule",
            "data entry",
        ),
        "OPERATIONS": (
            "operations",
            "fulfillment",
            "inventory",
            "logistics",
            "order processing",
            "process order",
        ),
    }

    @classmethod
    def classify(
        cls,
        activity: dict[str, Any],
    ) -> dict[str, Any]:
        """
        Classify an activity.

        Expected activity fields:
            name
            description
            activity_type
        """

        name = str(activity.get("name", ""))
        description = str(activity.get("description", ""))
        activity_type = str(
            activity.get("activity_type", "")
        )

        searchable_text = (
            f"{name} {description} {activity_type}"
        ).lower()

        scores: dict[str, int] = {
            category: 0
            for category in cls.CATEGORIES
        }

        matched_keywords: dict[str, list[str]] = {
            category: []
            for category in cls.CATEGORIES
        }

        for category, keywords in cls.KEYWORDS.items():
            for keyword in keywords:
                if keyword.lower() in searchable_text:
                    scores[category] += 1
                    matched_keywords[category].append(
                        keyword
                    )

        # Prefer the database's explicit activity type
        # when it maps to one of our categories.
        normalized_type = activity_type.upper()

        if normalized_type in scores:
            scores[normalized_type] += 3

        best_category = max(
            scores,
            key=scores.get,
        )

        best_score = scores[best_category]

        if best_score == 0:
            best_category = "OTHER"

        total_matches = sum(scores.values())

        if best_category == "OTHER":
            confidence = 0.40
        else:
            confidence = min(
                0.95,
                0.55 + (best_score * 0.10),
            )

            if total_matches > best_score:
                confidence -= 0.05

        return {
            "category": best_category,
            "confidence": round(
                max(0.0, confidence),
                2,
            ),
            "scores": scores,
            "matched_keywords": matched_keywords[
                best_category
            ],
        }