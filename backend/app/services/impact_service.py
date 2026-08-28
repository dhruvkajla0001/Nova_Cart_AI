from sqlalchemy import text
from sqlalchemy.orm import Session


class ImpactService:

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

        rows = list(result.mappings().all())

        if not rows:
            return None

        first = rows[0]

        opportunities = []

        for row in rows:
            if row["ai_opportunity_id"] is None:
                continue

            opportunities.append({
                "ai_opportunity_id": row["ai_opportunity_id"],
                "name": row["opportunity_name"],
                "description": row["opportunity_description"],
                "ai_type": row["ai_type"],
                "technology": row["technology"],
                "automation_score": row["automation_score"],
                "augmentation_score": row["augmentation_score"],
                "confidence_score": row["confidence_score"],
                "status": row["status"],
            })

        return {
            "activity": {
                "activity_id": first["activity_id"],
                "activity_code": first["activity_code"],
                "name": first["name"],
                "description": first["description"],
                "activity_type": first["activity_type"],
                "sequence_order": first["sequence_order"],
            },
            "ai_opportunities": opportunities,
        }


    @staticmethod
    def get_activity_cascade(
        db: Session,
        activity_id: int,
    ):
        """
        Return the complete AI impact cascade for an activity.

        Level 1 → Direct activity impact
        Level 2 → Role/activity impact
        Level 3 → Skill impact
        Level 4 → Future role impact
        Level 5 → Future skill impact
        """

        # ========================================================
        # SOURCE ACTIVITY
        # ========================================================

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

        activity = activity_result.mappings().first()

        if activity is None:
            return None


        # ========================================================
        # CASCADE DATA
        # ========================================================

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
                ON aa.activity_id = c.affected_activity_id

            LEFT JOIN roles r
                ON r.role_id = c.affected_role_id

            LEFT JOIN skills s
                ON s.skill_id = c.affected_skill_id

            WHERE c.source_activity_id = :activity_id

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


        # ========================================================
        # LEVEL STRUCTURE
        # ========================================================

        levels = {
            1: [],
            2: [],
            3: [],
            4: [],
            5: [],
        }


        # ========================================================
        # BUILD CASCADE RECORDS
        # ========================================================

        for row in rows:

            item = {
                "cascade_id": row["cascade_id"],
                "impact_level": row["impact_level"],
                "impact_score": row["impact_score"],
                "reasoning": row["reasoning"],

                "source": {
                    "activity_id": row["source_activity_id"],
                    "ai_opportunity_id": row[
                        "source_ai_opportunity_id"
                    ],
                },

                "affected_activity": None,
                "affected_role": None,
                "affected_skill": None,
            }


            # ----------------------------------------------------
            # Activity
            # ----------------------------------------------------

            if row["affected_activity_id"] is not None:

                item["affected_activity"] = {
                    "activity_id": row[
                        "affected_activity_id"
                    ],
                    "activity_code": row[
                        "affected_activity_code"
                    ],
                    "name": row[
                        "affected_activity_name"
                    ],
                }


            # ----------------------------------------------------
            # Role
            # ----------------------------------------------------

            if row["affected_role_id"] is not None:

                item["affected_role"] = {
                    "role_id": row[
                        "affected_role_id"
                    ],
                    "role_code": row[
                        "affected_role_code"
                    ],
                    "name": row[
                        "affected_role_name"
                    ],
                    "seniority_level": row[
                        "affected_role_seniority"
                    ],
                }


            # ----------------------------------------------------
            # Skill
            # ----------------------------------------------------

            if row["affected_skill_id"] is not None:

                item["affected_skill"] = {
                    "skill_id": row[
                        "affected_skill_id"
                    ],
                    "skill_code": row[
                        "affected_skill_code"
                    ],
                    "name": row[
                        "affected_skill_name"
                    ],
                    "category": row[
                        "affected_skill_category"
                    ],
                    "skill_type": row[
                        "affected_skill_type"
                    ],
                }


            level = row["impact_level"]

            if level not in levels:
                levels[level] = []

            levels[level].append(item)


        # ========================================================
        # RETURN COMPLETE CASCADE
        # ========================================================

        return {
            "activity": {
                "activity_id": activity["activity_id"],
                "activity_code": activity["activity_code"],
                "name": activity["name"],
                "description": activity["description"],
                "activity_type": activity["activity_type"],
                "sequence_order": activity["sequence_order"],
                "process_id": activity["process_id"],
            },

            "cascade": {
                "level_1_direct": levels[1],
                "level_2_role_activity": levels[2],
                "level_3_skill": levels[3],
                "level_4_future_role": levels[4],
                "level_5_future_skill": levels[5],
            },

            "summary": {
                "total_cascade_records": len(rows),

                "level_1_count": len(levels[1]),
                "level_2_count": len(levels[2]),
                "level_3_count": len(levels[3]),
                "level_4_count": len(levels[4]),
                "level_5_count": len(levels[5]),
            },
        }