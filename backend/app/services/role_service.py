from __future__ import annotations

from sqlalchemy.orm import Session

from app.db.repositories import GraphRepository


class RoleService:
    """
    Business logic for role-related operations.
    """

    @staticmethod
    def get_role(
        db: Session,
        role_id: int,
    ):
        return GraphRepository.get_role(
            db,
            role_id,
        )

    @staticmethod
    def get_role_skills(
        db: Session,
        role_id: int,
    ):
        return GraphRepository.get_role_skills(
            db,
            role_id,
        )

    @staticmethod
    def get_skill_roles(
        db: Session,
        skill_id: int,
    ):
        return GraphRepository.get_skill_roles(
            db,
            skill_id,
        )