from sqlalchemy.orm import Session

from app.db.repositories import GraphRepository


class GraphService:

    @staticmethod
    def get_industries(db: Session):
        return GraphRepository.get_industries(db)

    @staticmethod
    def get_value_chains(
        db: Session,
        industry_id: int,
    ):
        return GraphRepository.get_value_chains(
            db,
            industry_id,
        )

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
    def get_skill(
        db: Session,
        skill_id: int,
    ):
        return GraphRepository.get_skill(
            db,
            skill_id,
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