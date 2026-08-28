from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/graph",
    tags=["Graph"],
)


# ============================================================
# GRAPH — PROCESS
# ============================================================

@router.get("/processes/{process_id}")
def get_process_graph(
    process_id: int,
    db: Session = Depends(get_db),
):
    process = GraphService.get_process(
        db,
        process_id,
    )

    if process is None:
        return {
            "error": "Process not found"
        }

    activities = GraphService.get_process_activities(
        db,
        process_id,
    )

    roles = GraphService.get_process_roles(
        db,
        process_id,
    )

    return {
        "process": {
            "process_id": process.process_id,
            "process_code": process.process_code,
            "name": process.name,
            "description": process.description,
            "sequence_order": process.sequence_order,
            "value_chain_id": process.value_chain_id,
        },
        "activities": [
            {
                "activity_id": activity.activity_id,
                "activity_code": activity.activity_code,
                "name": activity.name,
                "description": activity.description,
                "activity_type": activity.activity_type,
                "sequence_order": activity.sequence_order,
            }
            for activity in activities
        ],
        "roles": [
            {
                "role_id": role.role_id,
                "role_code": role.role_code,
                "name": role.name,
                "description": role.description,
                "seniority_level": role.seniority_level,
            }
            for role in roles
        ],
    }


# ============================================================
# GRAPH — ROLE
# ============================================================

@router.get("/roles/{role_id}")
def get_role_graph(
    role_id: int,
    db: Session = Depends(get_db),
):
    role = GraphService.get_role(
        db,
        role_id,
    )

    if role is None:
        return {
            "error": "Role not found"
        }

    skills = GraphService.get_role_skills(
        db,
        role_id,
    )

    return {
        "role": {
            "role_id": role.role_id,
            "role_code": role.role_code,
            "name": role.name,
            "description": role.description,
            "seniority_level": role.seniority_level,
        },
        "skills": [
            {
                "skill_id": skill.skill_id,
                "skill_code": skill.skill_code,
                "name": skill.name,
                "description": skill.description,
                "category": skill.category,
                "skill_type": skill.skill_type,
            }
            for skill in skills
        ],
    }


# ============================================================
# GRAPH — SKILL
# ============================================================

@router.get("/skills/{skill_id}")
def get_skill_graph(
    skill_id: int,
    db: Session = Depends(get_db),
):
    skill = GraphService.get_skill(
        db,
        skill_id,
    )

    if skill is None:
        return {
            "error": "Skill not found"
        }

    roles = GraphService.get_skill_roles(
        db,
        skill_id,
    )

    return {
        "skill": {
            "skill_id": skill.skill_id,
            "skill_code": skill.skill_code,
            "name": skill.name,
            "description": skill.description,
            "category": skill.category,
            "skill_type": skill.skill_type,
        },
        "roles": [
            {
                "role_id": role.role_id,
                "role_code": role.role_code,
                "name": role.name,
                "description": role.description,
                "seniority_level": role.seniority_level,
            }
            for role in roles
        ],
    }