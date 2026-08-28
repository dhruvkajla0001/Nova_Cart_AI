from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/skills",
    tags=["Skills"],
)


@router.get("/{skill_id}")
def get_skill(
    skill_id: int,
    db: Session = Depends(get_db),
):
    skill = GraphService.get_skill(
        db,
        skill_id,
    )

    if skill is None:
        raise HTTPException(
            status_code=404,
            detail="Skill not found",
        )

    return {
        "skill_id": skill.skill_id,
        "skill_code": skill.skill_code,
        "name": skill.name,
        "description": skill.description,
        "category": skill.category,
        "skill_type": skill.skill_type,
    }


@router.get("/{skill_id}/roles")
def get_skill_roles(
    skill_id: int,
    db: Session = Depends(get_db),
):
    skill = GraphService.get_skill(
        db,
        skill_id,
    )

    if skill is None:
        raise HTTPException(
            status_code=404,
            detail="Skill not found",
        )

    roles = GraphService.get_skill_roles(
        db,
        skill_id,
    )

    return [
        {
            "role_id": role.role_id,
            "role_code": role.role_code,
            "name": role.name,
            "description": role.description,
            "seniority_level": role.seniority_level,
        }
        for role in roles
    ]