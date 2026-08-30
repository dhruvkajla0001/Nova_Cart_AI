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
# HELPERS
# ============================================================

def _activity_to_dict(activity):
    return {
        "activity_id": activity.activity_id,
        "activity_code": activity.activity_code,
        "name": activity.name,
        "description": activity.description,
        "activity_type": activity.activity_type,
        "sequence_order": activity.sequence_order,
        "process_id": activity.process_id,
    }


def _role_to_dict(role):
    return {
        "role_id": role.role_id,
        "role_code": role.role_code,
        "name": role.name,
        "description": role.description,
        "seniority_level": role.seniority_level,
    }


def _skill_to_dict(skill):
    return {
        "skill_id": skill.skill_id,
        "skill_code": skill.skill_code,
        "name": skill.name,
        "description": skill.description,
        "category": skill.category,
        "skill_type": skill.skill_type,
    }


# ============================================================
# COMPLETE AI INTELLIGENCE PIPELINE
# ============================================================

def _run_ai_pipeline(
    db: Session,
    activity_id: int,
):
    """
    Run the complete AI intelligence pipeline for
    an existing enterprise activity.

    PostgreSQL
        ↓
    Classification
        ↓
    Stored AI Opportunity
        ↓
    Graph Context
        ↓
    Structured AI Assessment
        ↓
    Impact Cascade
        ↓
    Local Llama Reasoning
    """

    # --------------------------------------------------------
    # 1. Retrieve activity
    # --------------------------------------------------------

    activity = GraphRepository.get_activity(
        db,
        activity_id,
    )

    if activity is None:
        return None

    activity_data = _activity_to_dict(
        activity
    )

    # --------------------------------------------------------
    # 2. Classification
    # --------------------------------------------------------

    classification = (
        ActivityClassifier.classify(
            activity_data
        )
    )

    # --------------------------------------------------------
    # 3. Retrieve stored AI opportunities
    # --------------------------------------------------------

    stored_ai = (
        ImpactService.get_activity_ai_analysis(
            db,
            activity_id,
        )
    )

    opportunities = []

    if stored_ai:
        opportunities = stored_ai.get(
            "ai_opportunities",
            [],
        )

    # --------------------------------------------------------
    # 4. Retrieve roles
    # --------------------------------------------------------

    roles = GraphRepository.get_activity_roles(
        db,
        activity_id,
    )

    role_data = [
        _role_to_dict(role)
        for role in roles
    ]

    # --------------------------------------------------------
    # 5. Retrieve skills
    # --------------------------------------------------------

    skills = GraphRepository.get_activity_skills(
        db,
        activity_id,
    )

    skill_data = [
        _skill_to_dict(skill)
        for skill in skills
    ]

    # --------------------------------------------------------
    # 6. Structured AI analysis
    # --------------------------------------------------------

    analysis = AIAnalyzer.analyze(
        activity=activity_data,
        classification=classification,
        opportunities=opportunities,
        roles=role_data,
        skills=skill_data,
    )

    # --------------------------------------------------------
    # 7. Retrieve impact cascade
    # --------------------------------------------------------

    cascade = (
        ImpactService.get_activity_cascade(
            db,
            activity_id,
        )
    )

    cascade_summary = {}

    if cascade:
        cascade_summary = cascade.get(
            "summary",
            {},
        )

    # --------------------------------------------------------
    # 8. Local Llama reasoning
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
    # 9. Return complete intelligence
    # --------------------------------------------------------

    return {
        "activity": activity_data,

        "classification": classification,

        "analysis": analysis,

        "llm_reasoning": reasoning,

        "graph_context": {
            "process": _get_process_context(
                db,
                activity.process_id,
            ),
            "roles": role_data,
            "skills": skill_data,
            "cascade_summary": cascade_summary,
        },
    }


# ============================================================
# PROCESS CONTEXT
# ============================================================

def _get_process_context(
    db: Session,
    process_id: int,
):
    """
    Retrieve the process associated with
    the selected activity.
    """

    process = (
        GraphRepository.get_process(
            db,
            process_id,
        )
    )

    if process is None:
        return None

    return {
        "process_id": process.process_id,
        "process_code": process.process_code,
        "name": process.name,
    }


# ============================================================
# GET COMPLETE AI ANALYSIS
# ============================================================

@router.get("/activities/{activity_id}")
def get_activity_ai_analysis(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Return complete AI intelligence for an
    existing enterprise activity.

    This endpoint is intentionally complete so
    the frontend only needs one request.
    """

    result = _run_ai_pipeline(
        db,
        activity_id,
    )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=(
                f"Activity {activity_id} not found"
            ),
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
    Retrieve the pre-computed AI impact cascade.

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

    result = (
        ImpactService.get_activity_cascade(
            db,
            activity_id,
        )
    )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=(
                f"Activity {activity_id} not found"
            ),
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
    Run runtime AI reasoning using local
    Llama 3.2.

    Kept as a dedicated endpoint for direct
    runtime reasoning requests.
    """

    result = _run_ai_pipeline(
        db,
        activity_id,
    )

    if result is None:
        raise HTTPException(
            status_code=404,
            detail=(
                f"Activity {activity_id} not found"
            ),
        )

    return result