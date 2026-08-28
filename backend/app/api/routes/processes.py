from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.services.graph_service import GraphService


router = APIRouter(
    prefix="/api",
    tags=["Processes"],
)


# ============================================================
# PROCESS
# ============================================================

@router.get("/processes/{process_id}")
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
        "sequence_order": process.sequence_order,
        "value_chain_id": process.value_chain_id,
    }


# ============================================================
# VALUE CHAIN → PROCESSES
# ============================================================

@router.get(
    "/value-chains/{value_chain_id}/processes"
)
def get_value_chain_processes(
    value_chain_id: int,
    db: Session = Depends(get_db),
):
    processes = GraphService.get_value_chain_processes(
        db,
        value_chain_id,
    )

    return [
        {
            "process_id": process.process_id,
            "process_code": process.process_code,
            "name": process.name,
            "description": process.description,
            "sequence_order": process.sequence_order,
            "value_chain_id": process.value_chain_id,
        }
        for process in processes
    ]


# ============================================================
# PROCESS → ACTIVITIES
# ============================================================

@router.get(
    "/processes/{process_id}/activities"
)
def get_process_activities(
    process_id: int,
    db: Session = Depends(get_db),
):
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
            "process_id": activity.process_id,
        }
        for activity in activities
    ]


# ============================================================
# PROCESS → ROLES
# ============================================================

@router.get(
    "/processes/{process_id}/roles"
)
def get_process_roles(
    process_id: int,
    db: Session = Depends(get_db),
):
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