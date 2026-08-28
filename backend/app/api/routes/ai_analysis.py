from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.ai.analyzer import AIAnalyzer
from app.ai.classifier import ActivityClassifier
from app.ai.reasoning import LlamaReasoner
from app.db.repositories import GraphRepository
from app.db.session import get_db
from app.services.impact_service import ImpactService


router = APIRouter(
    prefix="/api/ai-analysis",
    tags=["AI Analysis"],
)


# ============================================================
# STORED AI INTELLIGENCE
# ============================================================

@router.get("/activities/{activity_id}")
def get_activity_ai_analysis(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Retrieve stored AI opportunities for an activity.
    """

    result = ImpactService.get_activity_ai_analysis(
        db,
        activity_id,
    )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=f"Activity {activity_id} not found",
        )

    return result


# ============================================================
# PRE-COMPUTED AI IMPACT CASCADE
# ============================================================

@router.get("/activities/{activity_id}/cascade")
def get_activity_ai_cascade(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Retrieve the pre-computed cascading AI impact.

    Activity
        ↓
    AI Opportunity
        ↓
    AI Impact
        ↓
    Role
        ↓
    Skill
        ↓
    Future Role
        ↓
    Future Skill
    """

    result = ImpactService.get_activity_cascade(
        db,
        activity_id,
    )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=f"Activity {activity_id} not found",
        )

    return result


# ============================================================
# RUNTIME LLM REASONING
# ============================================================

@router.post("/activities/{activity_id}/reason")
def reason_about_activity(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Run runtime AI reasoning using local Llama 3.2.

    PostgreSQL provides verified graph facts.
    AIAnalyzer performs structured assessment.
    LlamaReasoner generates the natural-language reasoning.
    """

    # --------------------------------------------------------
    # 1. Retrieve activity
    # --------------------------------------------------------

    activity = GraphRepository.get_activity(
        db,
        activity_id,
    )

    if activity is None:
        raise HTTPException(
            status_code=404,
            detail=f"Activity {activity_id} not found",
        )

    # --------------------------------------------------------
    # 2. Convert activity model to dictionary
    # --------------------------------------------------------

    activity_data = {
        "activity_id": activity.activity_id,
        "activity_code": activity.activity_code,
        "name": activity.name,
        "description": activity.description,
        "activity_type": activity.activity_type,
        "sequence_order": activity.sequence_order,
        "process_id": activity.process_id,
    }

    # --------------------------------------------------------
    # 3. Classify activity
    # --------------------------------------------------------

    classification = ActivityClassifier.classify(
        activity_data
    )

    # --------------------------------------------------------
    # 4. Retrieve stored AI opportunities
    # --------------------------------------------------------

    stored_ai = ImpactService.get_activity_ai_analysis(
        db,
        activity_id,
    )

    opportunities = []

    if stored_ai:
        opportunities = stored_ai.get(
            "ai_opportunities",
            [],
        )

    # --------------------------------------------------------
    # 5. Retrieve affected roles
    # --------------------------------------------------------

    roles = GraphRepository.get_activity_roles(
        db,
        activity_id,
    )

    role_data = [
        {
            "role_id": role.role_id,
            "role_code": role.role_code,
            "name": role.name,
            "description": role.description,
            "seniority_level": role.seniority_level,
        }
        for role in roles
    ]

    # --------------------------------------------------------
    # 6. Retrieve activity skills
    # --------------------------------------------------------

    skills = GraphRepository.get_activity_skills(
        db,
        activity_id,
    )

    skill_data = [
        {
            "skill_id": skill.skill_id,
            "skill_code": skill.skill_code,
            "name": skill.name,
            "description": skill.description,
            "category": skill.category,
            "skill_type": skill.skill_type,
        }
        for skill in skills
    ]

    # --------------------------------------------------------
    # 7. Run structured AI analysis
    # --------------------------------------------------------

    analysis = AIAnalyzer.analyze(
        activity=activity_data,
        classification=classification,
        opportunities=opportunities,
        roles=role_data,
        skills=skill_data,
    )

    # --------------------------------------------------------
    # 8. Retrieve cascade context
    # --------------------------------------------------------

    cascade = ImpactService.get_activity_cascade(
        db,
        activity_id,
    )

    cascade_summary = {}

    if cascade:
        cascade_summary = cascade.get(
            "summary",
            {},
        )

    # --------------------------------------------------------
    # 9. Run local Llama 3.2 reasoning
    # --------------------------------------------------------

    reasoning = LlamaReasoner.reason(
        activity=activity_data,
        classification=classification,
        analysis=analysis,
        roles=role_data,
        skills=skill_data,
        cascade_summary=cascade_summary,
    )

    # --------------------------------------------------------
    # 10. Return complete intelligence response
    # --------------------------------------------------------

    return {
        "activity": activity_data,

        "classification": classification,

        "analysis": analysis,

        "llm_reasoning": reasoning,

        "graph_context": {
            "roles": role_data,
            "skills": skill_data,
            "cascade_summary": cascade_summary,
        },
    }