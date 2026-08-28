from sqlalchemy import select, text
from sqlalchemy.orm import Session

from app.models.activity import Activity
from app.models.industry import Industry
from app.models.process import Process
from app.models.role import Role
from app.models.skill import Skill
from app.models.value_chain import ValueChain

class DatabaseRepository:

    @staticmethod
    def health_check(db: Session) -> bool:
        result = db.execute(text("SELECT 1"))
        return result.scalar() == 1

class GraphRepository:

    @staticmethod
    def get_industries(db: Session) -> list[Industry]:
        statement = select(Industry).order_by(Industry.name)
        return list(db.scalars(statement).all())

    @staticmethod
    def get_value_chains(
        db: Session,
        industry_id: int,
    ) -> list[ValueChain]:
        statement = (
            select(ValueChain)
            .where(ValueChain.industry_id == industry_id)
            .order_by(ValueChain.sequence_order)
        )

        return list(db.scalars(statement).all())

    @staticmethod
    def get_process(
        db: Session,
        process_id: int,
    ) -> Process | None:
        statement = select(Process).where(
            Process.process_id == process_id
        )

        return db.scalar(statement)

    @staticmethod
    def get_process_activities(
        db: Session,
        process_id: int,
    ) -> list[Activity]:
        statement = (
            select(Activity)
            .where(Activity.process_id == process_id)
            .order_by(Activity.sequence_order)
        )

        return list(db.scalars(statement).all())

    @staticmethod
    def get_process_roles(
        db: Session,
        process_id: int,
    ) -> list[Role]:

        query = text("""
            SELECT DISTINCT
                r.role_id,
                r.role_code,
                r.name,
                r.description,
                r.seniority_level
            FROM roles r
            JOIN activity_roles ar
                ON ar.role_id = r.role_id
            JOIN activities a
                ON a.activity_id = ar.activity_id
            WHERE a.process_id = :process_id
            ORDER BY r.name
        """)

        result = db.execute(
            query,
            {"process_id": process_id},
        )

        return [
            Role(
                role_id=row.role_id,
                role_code=row.role_code,
                name=row.name,
                description=row.description,
                seniority_level=row.seniority_level,
            )
            for row in result
        ]

    @staticmethod
    def get_role(
        db: Session,
        role_id: int,
    ) -> Role | None:
        statement = select(Role).where(
            Role.role_id == role_id
        )

        return db.scalar(statement)

    @staticmethod
    def get_role_skills(
        db: Session,
        role_id: int,
    ) -> list[Skill]:

        query = text("""
            SELECT
                s.skill_id,
                s.skill_code,
                s.name,
                s.description,
                s.category,
                s.skill_type
            FROM skills s
            JOIN role_skills rs
                ON rs.skill_id = s.skill_id
            WHERE rs.role_id = :role_id
            ORDER BY s.name
        """)

        result = db.execute(
            query,
            {"role_id": role_id},
        )

        return [
            Skill(
                skill_id=row.skill_id,
                skill_code=row.skill_code,
                name=row.name,
                description=row.description,
                category=row.category,
                skill_type=row.skill_type,
            )
            for row in result
        ]

    @staticmethod
    def get_skill(
        db: Session,
        skill_id: int,
    ) -> Skill | None:
        statement = select(Skill).where(
            Skill.skill_id == skill_id
        )

        return db.scalar(statement)

    @staticmethod
    def get_skill_roles(
        db: Session,
        skill_id: int,
    ) -> list[Role]:

        query = text("""
            SELECT
                r.role_id,
                r.role_code,
                r.name,
                r.description,
                r.seniority_level
            FROM roles r
            JOIN role_skills rs
                ON rs.role_id = r.role_id
            WHERE rs.skill_id = :skill_id
            ORDER BY r.name
        """)

        result = db.execute(
            query,
            {"skill_id": skill_id},
        )

        return [
            Role(
                role_id=row.role_id,
                role_code=row.role_code,
                name=row.name,
                description=row.description,
                seniority_level=row.seniority_level,
            )
            for row in result
        ]