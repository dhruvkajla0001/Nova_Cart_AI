from __future__ import annotations

import re
from typing import Any

from sqlalchemy import text
from sqlalchemy.orm import Session

from app.models.activity import Activity
from app.models.ai_opportunity import AIOpportunity
from app.models.impact import AIImpactCascade


class ImpactService:

    # ============================================================
    # MATCHING CONFIGURATION
    # ============================================================

    STOP_WORDS = {
        "the",
        "a",
        "an",
        "and",
        "or",
        "of",
        "to",
        "for",
        "in",
        "on",
        "with",
        "by",
        "from",
        "is",
        "are",
        "this",
        "that",
        "as",
        "be",
        "before",
        "after",
        "into",
        "their",
        "its",
    }

    # Related enterprise concepts.
    # These improve matching when exact words differ.
    CONCEPT_GROUPS = (
        {
            "analysis",
            "analyze",
            "analytical",
            "evaluate",
            "evaluation",
            "assess",
            "assessment",
            "monitor",
            "monitoring",
            "measure",
            "metrics",
        },
        {
            "risk",
            "fraud",
            "compliance",
            "audit",
            "governance",
            "uncertainty",
        },
        {
            "supplier",
            "vendor",
            "procurement",
            "purchasing",
            "contract",
        },
        {
            "customer",
            "consumer",
            "client",
            "buyer",
        },
        {
            "marketing",
            "campaign",
            "acquisition",
            "conversion",
            "advertising",
            "promotion",
        },
        {
            "strategy",
            "strategic",
            "planning",
            "decision",
            "decisions",
            "prioritize",
            "recommend",
        },
        {
            "data",
            "analytics",
            "statistics",
            "sql",
            "reporting",
            "insights",
        },
        {
            "financial",
            "finance",
            "payment",
            "pricing",
            "revenue",
            "commercial",
        },
    )

    # ============================================================
    # TEXT UTILITIES
    # ============================================================

    @classmethod
    def _tokens(cls, text_value: str | None) -> set[str]:
        """
        Convert text into normalized tokens.
        """

        if not text_value:
            return set()

        words = re.findall(
            r"[a-zA-Z0-9]+",
            str(text_value).lower(),
        )

        return {
            word
            for word in words
            if word not in cls.STOP_WORDS
            and len(word) > 2
        }

    @classmethod
    def _concepts(cls, tokens: set[str]) -> set[str]:
        """
        Expand tokens into broader enterprise concepts.
        """

        concepts = set()

        for group in cls.CONCEPT_GROUPS:

            if tokens.intersection(group):
                concepts.add(
                    min(
                        group,
                        key=len,
                    )
                )

        return concepts

    @classmethod
    def _similarity_score(
        cls,
        source_text: str,
        target_text: str,
    ) -> float:
        """
        Calculate deterministic relevance between two texts.

        Score range:
            0 - 100
        """

        source_tokens = cls._tokens(
            source_text
        )

        target_tokens = cls._tokens(
            target_text
        )

        if not source_tokens or not target_tokens:
            return 0.0

        exact_matches = (
            source_tokens
            .intersection(target_tokens)
        )

        source_concepts = cls._concepts(
            source_tokens
        )

        target_concepts = cls._concepts(
            target_tokens
        )

        concept_matches = (
            source_concepts
            .intersection(target_concepts)
        )

        # Exact words are stronger evidence.
        exact_score = (
            len(exact_matches)
            / max(len(source_tokens), 1)
        ) * 70

        # Related concepts provide supporting evidence.
        concept_score = (
            len(concept_matches)
            / max(
                len(source_concepts),
                1,
            )
        ) * 30 if source_concepts else 0

        score = min(
            100.0,
            exact_score + concept_score,
        )

        return round(
            score,
            2,
        )

    # ============================================================
    # ROLE RELEVANCE
    # ============================================================

    @classmethod
    def _role_relevance(
        cls,
        activity: Activity,
        role: dict[str, Any],
    ) -> float:
        """
        Determine how strongly an activity relates to a role.
        """

        activity_text = " ".join(
            filter(
                None,
                [
                    activity.name,
                    activity.description,
                    activity.activity_type,
                ],
            )
        )

        role_text = " ".join(
            filter(
                None,
                [
                    role.get("name"),
                    role.get("description"),
                    role.get("seniority_level"),
                ],
            )
        )

        score = cls._similarity_score(
            activity_text,
            role_text,
        )

        # Activity category gives additional signal.
        activity_type = str(
            activity.activity_type or ""
        ).upper()

        role_description = str(
            role.get("description") or ""
        ).lower()

        if activity_type == "ANALYSIS" and (
            "analy" in role_description
            or "performance" in role_description
            or "analytics" in role_description
        ):
            score += 15

        if activity_type == "DECISION" and (
            "strategy" in role_description
            or "decision" in role_description
            or "manager" in role_description
        ):
            score += 15

        return round(
            min(100.0, score),
            2,
        )

    # ============================================================
    # SKILL RELEVANCE
    # ============================================================

    @classmethod
    def _skill_relevance(
        cls,
        activity: Activity,
        skill: dict[str, Any],
    ) -> float:
        """
        Determine how strongly an activity relates to a skill.
        """

        activity_text = " ".join(
            filter(
                None,
                [
                    activity.name,
                    activity.description,
                    activity.activity_type,
                ],
            )
        )

        skill_text = " ".join(
            filter(
                None,
                [
                    skill.get("name"),
                    skill.get("description"),
                    skill.get("category"),
                    skill.get("skill_type"),
                ],
            )
        )

        score = cls._similarity_score(
            activity_text,
            skill_text,
        )

        skill_type = str(
            skill.get("skill_type") or ""
        ).upper()

        activity_type = str(
            activity.activity_type or ""
        ).upper()

        # Analytical activities naturally affect analytical skills.
        if (
            activity_type == "ANALYSIS"
            and skill_type
            in {
                "ANALYTICAL",
                "TECHNICAL",
            }
        ):
            score += 20

        # Decision activities naturally affect cognitive/strategic skills.
        if (
            activity_type == "DECISION"
            and skill_type
            in {
                "COGNITIVE",
                "STRATEGIC",
            }
        ):
            score += 20

        return round(
            min(100.0, score),
            2,
        )

    # ============================================================
    # IMPACT SCORE
    # ============================================================

    @staticmethod
    def _impact_score(
        relevance: float,
        automation_score: float,
        augmentation_score: float,
    ) -> float:
        """
        Combine relationship relevance with AI transformation scores.
        """

        ai_pressure = (
            automation_score * 0.45
            + augmentation_score * 0.35
        )

        score = (
            relevance * 0.55
            + ai_pressure * 0.45
        )

        return round(
            min(100.0, score),
            2,
        )

    # ============================================================
    # GET ACTIVITY AI ANALYSIS
    # ============================================================

    @staticmethod
    def get_activity_ai_analysis(
        db: Session,
        activity_id: int,
    ):
        query = text("""
            SELECT
                a.activity_id,
                a.activity_code,
                a.name,
                a.description,
                a.activity_type,
                a.sequence_order,

                ao.ai_opportunity_id,
                ao.name AS opportunity_name,
                ao.description AS opportunity_description,
                ao.ai_type,
                ao.technology,
                ao.automation_score,
                ao.augmentation_score,
                ao.confidence_score,
                ao.status

            FROM activities a

            LEFT JOIN ai_opportunities ao
                ON ao.activity_id = a.activity_id

            WHERE a.activity_id = :activity_id

            ORDER BY ao.ai_opportunity_id
        """)

        result = db.execute(
            query,
            {"activity_id": activity_id},
        )

        rows = list(
            result.mappings().all()
        )

        if not rows:
            return None

        first = rows[0]

        opportunities = []

        for row in rows:

            if row[
                "ai_opportunity_id"
            ] is None:
                continue

            opportunities.append({
                "ai_opportunity_id":
                    row[
                        "ai_opportunity_id"
                    ],
                "name":
                    row[
                        "opportunity_name"
                    ],
                "description":
                    row[
                        "opportunity_description"
                    ],
                "ai_type":
                    row["ai_type"],
                "technology":
                    row["technology"],
                "automation_score":
                    row["automation_score"],
                "augmentation_score":
                    row["augmentation_score"],
                "confidence_score":
                    row["confidence_score"],
                "status":
                    row["status"],
            })

        return {
            "activity": {
                "activity_id":
                    first["activity_id"],
                "activity_code":
                    first["activity_code"],
                "name":
                    first["name"],
                "description":
                    first["description"],
                "activity_type":
                    first["activity_type"],
                "sequence_order":
                    first["sequence_order"],
            },
            "ai_opportunities":
                opportunities,
        }

    # ============================================================
    # GET ACTIVITY CASCADE
    # ============================================================

    @staticmethod
    def get_activity_cascade(
        db: Session,
        activity_id: int,
    ):
        activity_query = text("""
            SELECT
                activity_id,
                activity_code,
                name,
                description,
                activity_type,
                sequence_order,
                process_id
            FROM activities
            WHERE activity_id = :activity_id
        """)

        activity_result = db.execute(
            activity_query,
            {"activity_id": activity_id},
        )

        activity = (
            activity_result
            .mappings()
            .first()
        )

        if activity is None:
            return None

        cascade_query = text("""
            SELECT
                c.cascade_id,
                c.source_activity_id,
                c.source_ai_opportunity_id,

                c.impact_level,
                c.impact_score,
                c.reasoning,

                c.affected_activity_id,
                aa.activity_code AS affected_activity_code,
                aa.name AS affected_activity_name,

                c.affected_role_id,
                r.role_code AS affected_role_code,
                r.name AS affected_role_name,
                r.seniority_level AS affected_role_seniority,

                c.affected_skill_id,
                s.skill_code AS affected_skill_code,
                s.name AS affected_skill_name,
                s.category AS affected_skill_category,
                s.skill_type AS affected_skill_type

            FROM ai_impact_cascade c

            LEFT JOIN activities aa
                ON aa.activity_id =
                    c.affected_activity_id

            LEFT JOIN roles r
                ON r.role_id =
                    c.affected_role_id

            LEFT JOIN skills s
                ON s.skill_id =
                    c.affected_skill_id

            WHERE c.source_activity_id =
                :activity_id

            ORDER BY
                c.impact_level ASC,
                c.impact_score DESC NULLS LAST,
                c.cascade_id ASC
        """)

        result = db.execute(
            cascade_query,
            {"activity_id": activity_id},
        )

        rows = result.mappings().all()

        levels = {
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
        }

        for row in rows:

            item = {
                "cascade_id":
                    row["cascade_id"],
                "impact_level":
                    row["impact_level"],
                "impact_score":
                    row["impact_score"],
                "reasoning":
                    row["reasoning"],

                "source": {
                    "activity_id":
                        row[
                            "source_activity_id"
                        ],
                    "ai_opportunity_id":
                        row[
                            "source_ai_opportunity_id"
                        ],
                },

                "affected_activity": None,
                "affected_role": None,
                "affected_skill": None,
            }

            if row[
                "affected_activity_id"
            ] is not None:

                item[
                    "affected_activity"
                ] = {
                    "activity_id":
                        row[
                            "affected_activity_id"
                        ],
                    "activity_code":
                        row[
                            "affected_activity_code"
                        ],
                    "name":
                        row[
                            "affected_activity_name"
                        ],
                }

            if row[
                "affected_role_id"
            ] is not None:

                item[
                    "affected_role"
                ] = {
                    "role_id":
                        row[
                            "affected_role_id"
                        ],
                    "role_code":
                        row[
                            "affected_role_code"
                        ],
                    "name":
                        row[
                            "affected_role_name"
                        ],
                    "seniority_level":
                        row[
                            "affected_role_seniority"
                        ],
                }

            if row[
                "affected_skill_id"
            ] is not None:

                item[
                    "affected_skill"
                ] = {
                    "skill_id":
                        row[
                            "affected_skill_id"
                        ],
                    "skill_code":
                        row[
                            "affected_skill_code"
                        ],
                    "name":
                        row[
                            "affected_skill_name"
                        ],
                    "category":
                        row[
                            "affected_skill_category"
                        ],
                    "skill_type":
                        row[
                            "affected_skill_type"
                        ],
                }

            level = row[
                "impact_level"
            ]

            if level not in levels:
                levels[level] = []

            levels[level].append(item)

        return {
            "activity": {
                "activity_id":
                    activity[
                        "activity_id"
                    ],
                "activity_code":
                    activity[
                        "activity_code"
                    ],
                "name":
                    activity["name"],
                "description":
                    activity["description"],
                "activity_type":
                    activity[
                        "activity_type"
                    ],
                "sequence_order":
                    activity[
                        "sequence_order"
                    ],
                "process_id":
                    activity["process_id"],
            },

            "cascade": {
                "level_1_direct":
                    levels[1],
                "level_2_role_activity":
                    levels[2],
                "level_3_skill":
                    levels[3],
                "level_4_future_role":
                    levels[4],
                "level_5_future_skill":
                    levels[5],
            },

            "summary": {
                "total_cascade_records":
                    len(rows),
                "level_1_count":
                    len(levels[1]),
                "level_2_count":
                    len(levels[2]),
                "level_3_count":
                    len(levels[3]),
                "level_4_count":
                    len(levels[4]),
                "level_5_count":
                    len(levels[5]),
            },
        }

    # ============================================================
    # CREATE INTELLIGENT ACTIVITY CASCADE
    # ============================================================

    @classmethod
    def create_activity_cascade(
        cls,
        db: Session,
        activity: Activity,
        opportunity: AIOpportunity,
        roles: list[dict[str, Any]],
        skills: list[dict[str, Any]],
    ) -> list[AIImpactCascade]:
        """
        Generate relevance-based workforce impact.

        Unlike the previous implementation, this does NOT
        automatically impact every role and skill.

        Only sufficiently relevant roles and skills are included.
        """

        cascade_records: list[
            AIImpactCascade
        ] = []

        automation_score = float(
            opportunity.automation_score
            or 0
        )

        augmentation_score = float(
            opportunity.augmentation_score
            or 0
        )

        # ========================================================
        # ROLE MATCHING
        # ========================================================

        for role in roles:

            relevance = cls._role_relevance(
                activity,
                role,
            )

            # Ignore weak relationships.
            if relevance < 25:
                continue

            impact_score = cls._impact_score(
                relevance,
                automation_score,
                augmentation_score,
            )

            reasoning = (
                f'Dynamic relevance match: activity '
                f'"{activity.name}" has a '
                f'{relevance:.0f}% relevance to role '
                f'"{role.get("name")}". '
                f'The role description and activity context '
                f'indicate a meaningful workforce impact.'
            )

            cascade = AIImpactCascade(
                source_activity_id=
                    activity.activity_id,

                source_ai_opportunity_id=(
                    opportunity.ai_opportunity_id
                ),

                affected_activity_id=
                    activity.activity_id,

                affected_role_id=
                    role.get("role_id"),

                affected_skill_id=None,

                impact_level=1,

                impact_score=impact_score,

                reasoning=reasoning,
            )

            db.add(cascade)
            cascade_records.append(cascade)

        # ========================================================
        # SKILL MATCHING
        # ========================================================

        for skill in skills:

            relevance = cls._skill_relevance(
                activity,
                skill,
            )

            if relevance < 25:
                continue

            impact_score = cls._impact_score(
                relevance,
                automation_score,
                augmentation_score,
            )

            reasoning = (
                f'Dynamic relevance match: activity '
                f'"{activity.name}" has a '
                f'{relevance:.0f}% relevance to skill '
                f'"{skill.get("name")}". '
                f'The skill characteristics indicate that '
                f'AI may change how this capability is applied.'
            )

            cascade = AIImpactCascade(
                source_activity_id=
                    activity.activity_id,

                source_ai_opportunity_id=(
                    opportunity.ai_opportunity_id
                ),

                affected_activity_id=
                    activity.activity_id,

                affected_role_id=None,

                affected_skill_id=
                    skill.get("skill_id"),

                impact_level=3,

                impact_score=impact_score,

                reasoning=reasoning,
            )

            db.add(cascade)
            cascade_records.append(cascade)

        db.flush()

        return cascade_records