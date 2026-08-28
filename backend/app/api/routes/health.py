from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.db.repositories import DatabaseRepository
from app.db.session import get_db


router = APIRouter(
    prefix="/health",
    tags=["Health"],
)


@router.get("")
def health_check(db: Session = Depends(get_db)):
    database_ok = DatabaseRepository.health_check(db)

    return {
        "status": "ok",
        "service": "novacart-ai",
        "database": "connected" if database_ok else "disconnected",
    }