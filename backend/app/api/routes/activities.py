from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/activities",
    tags=["Activities"],
)


@router.get("/{activity_id}")
def get_activity(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Get details about a specific activity.
    """

    activity = GraphService.get_activity(
        db,
        activity_id,
    )

    if activity is None:
        raise HTTPException(
            status_code=404,
            detail="Activity not found",
        )

    return {
        "activity_id": activity.activity_id,
        "activity_code": activity.activity_code,
        "name": activity.name,
        "description": activity.description,
        "activity_type": activity.activity_type,
        "automation_level": activity.automation_level,
        "process_id": activity.process_id,
        "sequence_order": activity.sequence_order,
    }


@router.get("/{activity_id}/roles")
def get_activity_roles(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Get roles responsible for an activity.
    """

    activity = GraphService.get_activity(
        db,
        activity_id,
    )

    if activity is None:
        raise HTTPException(
            status_code=404,
            detail="Activity not found",
        )

    roles = GraphService.get_activity_roles(
        db,
        activity_id,
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


@router.get("/{activity_id}/skills")
def get_activity_skills(
    activity_id: int,
    db: Session = Depends(get_db),
):
    """
    Get skills directly associated with an activity.
    """

    activity = GraphService.get_activity(
        db,
        activity_id,
    )

    if activity is None:
        raise HTTPException(
            status_code=404,
            detail="Activity not found",
        )

    skills = GraphService.get_activity_skills(
        db,
        activity_id,
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