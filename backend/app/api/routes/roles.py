
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/roles",
    tags=["Roles"],
)


@router.get("/{role_id}")
def get_role(
    role_id: int,
    db: Session = Depends(get_db),
):
    role = GraphService.get_role(
        db,
        role_id,
    )

    if role is None:
        raise HTTPException(
            status_code=404,
            detail="Role not found",
        )

    return {
        "role_id": role.role_id,
        "role_code": role.role_code,
        "name": role.name,
        "description": role.description,
        "seniority_level": role.seniority_level,
    }


@router.get("/{role_id}/skills")
def get_role_skills(
    role_id: int,
    db: Session = Depends(get_db),
):
    role = GraphService.get_role(
        db,
        role_id,
    )

    if role is None:
        raise HTTPException(
            status_code=404,
            detail="Role not found",
        )

    skills = GraphService.get_role_skills(
        db,
        role_id,
    )

    return [
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