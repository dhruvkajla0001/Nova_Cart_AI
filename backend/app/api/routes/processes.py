from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api/processes",
    tags=["Processes"],
)


@router.get("/{process_id}")
def get_process(
    process_id: int,
    db: Session = Depends(get_db),
):
    process = GraphService.get_process(
        db,
        process_id,
    )

    if process is None:
        raise HTTPException(
            status_code=404,
            detail="Process not found",
        )

    return {
        "process_id": process.process_id,
        "process_code": process.process_code,
        "name": process.name,
        "description": process.description,
        "value_chain_id": process.value_chain_id,
    }


@router.get("/{process_id}/activities")
def get_process_activities(
    process_id: int,
    db: Session = Depends(get_db),
):
    process = GraphService.get_process(
        db,
        process_id,
    )

    if process is None:
        raise HTTPException(
            status_code=404,
            detail="Process not found",
        )

    activities = GraphService.get_process_activities(
        db,
        process_id,
    )

    return [
        {
            "activity_id": activity.activity_id,
            "activity_code": activity.activity_code,
            "name": activity.name,
            "description": activity.description,
            "activity_type": activity.activity_type,
            "sequence_order": activity.sequence_order,
        }
        for activity in activities
    ]


@router.get("/{process_id}/roles")
def get_process_roles(
    process_id: int,
    db: Session = Depends(get_db),
):
    process = GraphService.get_process(
        db,
        process_id,
    )

    if process is None:
        raise HTTPException(
            status_code=404,
            detail="Process not found",
        )

    roles = GraphService.get_process_roles(
        db,
        process_id,
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