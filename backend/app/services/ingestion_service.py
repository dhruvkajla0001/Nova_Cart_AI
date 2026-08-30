from __future__ import annotations

from typing import Any

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.ai.analyzer import AIAnalyzer
from app.ai.classifier import ActivityClassifier
from app.ai.extractor import ActivityExtractor
from app.ai.reasoning import LlamaReasoner

from app.models.activity import Activity
from app.models.ai_opportunity import AIOpportunity

from app.services.graph_service import GraphService
from app.services.impact_service import ImpactService


class ActivityIngestionService:
    """
    Dynamic Surprise Record ingestion pipeline.

    Flow:

        Input
          ↓
        Extract / Validate
          ↓
        Validate Process
          ↓
        Classify
          ↓
        Retrieve Graph Context
          ↓
        AI Analysis
          ↓
        Persist Activity
          ↓
        Persist AI Opportunity
          ↓
        Generate Impact Cascade
          ↓
        Llama 3.2 Reasoning
          ↓
        Commit
          ↓
        Return Complete Result
    """

    # ============================================================
    # ACTIVITY CODE
    # ============================================================

    @staticmethod
    def _generate_activity_code(
        db: Session,
    ) -> str:
        """
        Generate a unique runtime activity code.

        Example:
            ACT_RUNTIME_000081
        """

        statement = (
            select(Activity.activity_id)
            .order_by(Activity.activity_id.desc())
            .limit(1)
        )

        latest_id = db.scalar(statement)

        next_number = (latest_id or 0) + 1

        return f"ACT_RUNTIME_{next_number:06d}"

    # ============================================================
    # SERIALIZATION
    # ============================================================

    @staticmethod
    def _serialize_role(
        role,
    ) -> dict[str, Any]:
        return {
            "role_id": role.role_id,
            "role_code": role.role_code,
            "name": role.name,
            "description": role.description,
            "seniority_level": role.seniority_level,
        }

    @staticmethod
    def _serialize_skill(
        skill,
    ) -> dict[str, Any]:
        return {
            "skill_id": skill.skill_id,
            "skill_code": skill.skill_code,
            "name": skill.name,
            "description": skill.description,
            "category": skill.category,
            "skill_type": skill.skill_type,
        }

    # ============================================================
    # GRAPH CONTEXT
    # ============================================================

    @classmethod
    def _get_process_context(
        cls,
        db: Session,
        process_id: int,
    ) -> tuple[
        list[dict[str, Any]],
        list[dict[str, Any]],
    ]:
        """
        Retrieve existing workforce context for the process.

        Roles are obtained from the existing graph.

        Skills are collected from those roles and
        deduplicated by skill_id.
        """

        roles = GraphService.get_process_roles(
            db,
            process_id,
        )

        role_data = [
            cls._serialize_role(role)
            for role in roles
        ]

        skills_by_id: dict[
            int,
            dict[str, Any],
        ] = {}

        for role in roles:

            role_skills = (
                GraphService.get_role_skills(
                    db,
                    role.role_id,
                )
            )

            for skill in role_skills:

                skills_by_id[
                    skill.skill_id
                ] = cls._serialize_skill(
                    skill
                )

        return (
            role_data,
            list(skills_by_id.values()),
        )

    # ============================================================
    # AI OPPORTUNITY
    # ============================================================

    @staticmethod
    def _build_opportunity(
        activity: Activity,
        analysis: dict[str, Any],
    ) -> AIOpportunity:
        """
        Convert deterministic AI analysis into
        a persistent AI opportunity record.
        """

        assessment = analysis[
            "ai_assessment"
        ]

        primary = analysis.get(
            "ai_opportunity"
        )

        automation_score = float(
            assessment.get(
                "automation_score",
                0,
            )
        )

        augmentation_score = float(
            assessment.get(
                "augmentation_score",
                0,
            )
        )

        confidence = float(
            assessment.get(
                "confidence",
                0,
            )
        ) * 100

        if primary:

            name = (
                primary.get("name")
                or
                f"AI Opportunity for {activity.name}"
            )

            ai_type = primary.get(
                "ai_type"
            )

            technology = primary.get(
                "technology"
            )

        else:

            name = (
                f"AI Opportunity for {activity.name}"
            )

            ai_type = (
                "INTELLIGENT_AUTOMATION"
            )

            technology = (
                "Machine Learning + Analytics"
            )

        description = (
            f"Apply AI to analyze, automate, "
            f"optimize, or augment this activity "
            f"based on its process context and "
            f"available enterprise data."
        )

        return AIOpportunity(
            activity_id=activity.activity_id,
            name=name,
            description=description,
            ai_type=ai_type,
            technology=technology,
            automation_score=automation_score,
            augmentation_score=augmentation_score,
            confidence_score=confidence,
            status="identified",
        )

    # ============================================================
    # CASCADE SERIALIZATION
    # ============================================================

    @staticmethod
    def _serialize_cascade(
        cascade,
    ) -> dict[str, Any]:
        """
        Convert an AIImpactCascade ORM object
        into a JSON-safe response.
        """

        return {
            "cascade_id": cascade.cascade_id,
            "source_activity_id":
                cascade.source_activity_id,
            "source_ai_opportunity_id":
                cascade.source_ai_opportunity_id,
            "affected_activity_id":
                cascade.affected_activity_id,
            "affected_role_id":
                cascade.affected_role_id,
            "affected_skill_id":
                cascade.affected_skill_id,
            "impact_level":
                cascade.impact_level,
            "impact_score": (
                float(cascade.impact_score)
                if cascade.impact_score is not None
                else None
            ),
            "reasoning":
                cascade.reasoning,
        }

    # ============================================================
    # MAIN INGESTION PIPELINE
    # ============================================================

    @classmethod
    def ingest(
        cls,
        db: Session,
        payload: dict[str, Any],
    ) -> dict[str, Any]:

        try:

            # ====================================================
            # 1. EXTRACT / VALIDATE INPUT
            # ====================================================

            data = ActivityExtractor.extract(
                payload
            )

            process_id = data[
                "process_id"
            ]

            # ====================================================
            # 2. VALIDATE PROCESS
            # ====================================================

            process = GraphService.get_process(
                db,
                process_id,
            )

            if process is None:
                raise ValueError(
                    f"Process {process_id} not found."
                )

            # ====================================================
            # 3. BUILD INITIAL ACTIVITY CONTEXT
            # ====================================================

            activity_context = {
                "activity_id": None,
                "activity_code": None,
                "name": data["name"],
                "description": data[
                    "description"
                ],
                "activity_type": data[
                    "activity_type"
                ],
                "process_id": process_id,
            }

            # ====================================================
            # 4. CLASSIFICATION
            # ====================================================

            classification = (
                ActivityClassifier.classify(
                    activity_context
                )
            )

            # If caller didn't provide a type,
            # classifier determines it.

            if not activity_context[
                "activity_type"
            ]:

                activity_context[
                    "activity_type"
                ] = classification[
                    "category"
                ]

            # ====================================================
            # 5. RETRIEVE GRAPH CONTEXT
            # ====================================================

            roles, skills = (
                cls._get_process_context(
                    db,
                    process_id,
                )
            )

            # ====================================================
            # 6. AI ANALYSIS
            # ====================================================

            analysis = AIAnalyzer.analyze(
                activity=activity_context,
                classification=classification,
                opportunities=[],
                roles=roles,
                skills=skills,
            )

            # ====================================================
            # 7. GENERATE RUNTIME CODE
            # ====================================================

            activity_code = (
                cls._generate_activity_code(
                    db
                )
            )

            # ====================================================
            # 8. CREATE ACTIVITY
            # ====================================================

            activity = Activity(
                process_id=process_id,
                activity_code=activity_code,
                name=data["name"],
                description=data[
                    "description"
                ],
                activity_type=activity_context[
                    "activity_type"
                ],
                automation_level=(
                    analysis[
                        "ai_assessment"
                    ][
                        "automation_score"
                    ]
                ),
                sequence_order=0,
            )

            db.add(activity)

            # Generate database ID.
            db.flush()

            # ====================================================
            # 9. UPDATE CONTEXT WITH REAL DATABASE ID
            # ====================================================

            activity_context[
                "activity_id"
            ] = activity.activity_id

            activity_context[
                "activity_code"
            ] = activity.activity_code

            # ====================================================
            # 10. UPDATE ANALYSIS WITH REAL ACTIVITY
            # ====================================================

            analysis[
                "activity"
            ] = {
                "activity_id":
                    activity.activity_id,
                "activity_code":
                    activity.activity_code,
                "name":
                    activity.name,
                "activity_type":
                    activity.activity_type,
            }

            # ====================================================
            # 11. CREATE AI OPPORTUNITY
            # ====================================================

            opportunity = (
                cls._build_opportunity(
                    activity,
                    analysis,
                )
            )

            db.add(opportunity)

            # Generate AI opportunity ID.
            db.flush()

            # ====================================================
            # 12. UPDATE ANALYSIS OPPORTUNITY
            # ====================================================

            analysis[
                "ai_opportunity"
            ] = {
                "ai_opportunity_id":
                    opportunity.ai_opportunity_id,
                "name":
                    opportunity.name,
                "ai_type":
                    opportunity.ai_type,
                "technology":
                    opportunity.technology,
            }

            # ====================================================
            # 13. GENERATE INTELLIGENT IMPACT CASCADE
            # ====================================================

            cascade_records = (
                ImpactService.create_activity_cascade(
                    db=db,
                    activity=activity,
                    opportunity=opportunity,
                    roles=roles,
                    skills=skills,
                )
            )

            # ====================================================
            # 14. BUILD CASCADE SUMMARY
            # ====================================================

            role_impacts = sum(
                1
                for record in cascade_records
                if record.affected_role_id
                is not None
            )

            skill_impacts = sum(
                1
                for record in cascade_records
                if record.affected_skill_id
                is not None
            )

            cascade_summary = {
                "total_records":
                    len(cascade_records),

                "role_impacts":
                    role_impacts,

                "skill_impacts":
                    skill_impacts,
            }

            # ====================================================
            # 15. LLAMA 3.2 REASONING
            # ====================================================

            llm_reasoning = (
                LlamaReasoner.reason(
                    activity=activity_context,
                    classification=classification,
                    analysis=analysis,
                    roles=roles,
                    skills=skills,
                    cascade_summary=cascade_summary,
                )
            )

            # ====================================================
            # 16. COMMIT EVERYTHING
            # ====================================================

            db.commit()

            # Refresh persisted records.

            db.refresh(activity)
            db.refresh(opportunity)

            # ====================================================
            # 17. FINAL RESPONSE
            # ====================================================

            return {
                "status": "created",

                "activity": {
                    "activity_id":
                        activity.activity_id,

                    "activity_code":
                        activity.activity_code,

                    "name":
                        activity.name,

                    "description":
                        activity.description,

                    "activity_type":
                        activity.activity_type,

                    "automation_level":
                        activity.automation_level,

                    "process_id":
                        activity.process_id,

                    "sequence_order":
                        activity.sequence_order,
                },

                "classification":
                    classification,

                "analysis":
                    analysis,

                "llm_reasoning":
                    llm_reasoning,

                "graph_context": {
                    "process": {
                        "process_id":
                            process.process_id,

                        "process_code":
                            process.process_code,

                        "name":
                            process.name,
                    },

                    "roles":
                        roles,

                    "skills":
                        skills,
                },

                "cascade": {
                    "total_records":
                        len(cascade_records),

                    "role_impacts":
                        role_impacts,

                    "skill_impacts":
                        skill_impacts,

                    "records": [
                        cls._serialize_cascade(
                            record
                        )
                        for record
                        in cascade_records
                    ],
                },
            }

        except Exception:

            db.rollback()

            raise