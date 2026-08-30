from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.db.session import get_db
from app.schemas.ingestion import ActivityIngestionRequest
from app.services.ingestion_service import (
    ActivityIngestionService,
)


router = APIRouter(
    prefix="/api/ingestion",
    tags=["Ingestion"],
)


@router.post(
    "/activities",
)
def ingest_activity(
    payload: ActivityIngestionRequest,
    db: Session = Depends(get_db),
):
    """
    Dynamically ingest and analyze a new activity.

    This endpoint is designed for the
    Modus ETI Surprise Record test.
    """

    try:

        return ActivityIngestionService.ingest(
            db,
            payload.model_dump(),
        )

    except ValueError as exc:

        raise HTTPException(
            status_code=400,
            detail=str(exc),
        )

    except Exception as exc:

        db.rollback()

        raise HTTPException(
            status_code=500,
            detail=(
                "Failed to ingest activity: "
                f"{exc}"
            ),
        )