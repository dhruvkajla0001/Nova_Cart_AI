from __future__ import annotations

from sqlalchemy.orm import Session

from app.db.repositories import GraphRepository


class ProcessService:
    """
    Business logic for process-related operations.
    """

    @staticmethod
    def get_process(
        db: Session,
        process_id: int,
    ):
        return GraphRepository.get_process(
            db,
            process_id,
        )

    @staticmethod
    def get_process_activities(
        db: Session,
        process_id: int,
    ):
        return GraphRepository.get_process_activities(
            db,
            process_id,
        )

    @staticmethod
    def get_process_roles(
        db: Session,
        process_id: int,
    ):
        return GraphRepository.get_process_roles(
            db,
            process_id,
        )