from __future__ import annotations

from datetime import datetime

from sqlalchemy import (
    BigInteger,
    ForeignKey,
    Integer,
    Numeric,
    Text,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class AIImpactCascade(Base):
    __tablename__ = "ai_impact_cascade"

    # ============================================================
    # PRIMARY KEY
    # ============================================================

    cascade_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    # ============================================================
    # SOURCE ACTIVITY
    # ============================================================

    source_activity_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey(
            "activities.activity_id",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    # ============================================================
    # SOURCE AI OPPORTUNITY
    # ============================================================

    source_ai_opportunity_id: Mapped[int | None] = mapped_column(
        BigInteger,
        ForeignKey(
            "ai_opportunities.ai_opportunity_id",
            ondelete="SET NULL",
        ),
        nullable=True,
    )

    # ============================================================
    # AFFECTED ACTIVITY
    # ============================================================

    affected_activity_id: Mapped[int | None] = mapped_column(
        BigInteger,
        ForeignKey(
            "activities.activity_id",
            ondelete="CASCADE",
        ),
        nullable=True,
    )

    # ============================================================
    # AFFECTED ROLE
    # ============================================================

    affected_role_id: Mapped[int | None] = mapped_column(
        BigInteger,
        ForeignKey(
            "roles.role_id",
            ondelete="CASCADE",
        ),
        nullable=True,
    )

    # ============================================================
    # AFFECTED SKILL
    # ============================================================

    affected_skill_id: Mapped[int | None] = mapped_column(
        BigInteger,
        ForeignKey(
            "skills.skill_id",
            ondelete="CASCADE",
        ),
        nullable=True,
    )

    # ============================================================
    # IMPACT
    # ============================================================

    impact_level: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=1,
    )

    impact_score: Mapped[float | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    reasoning: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    # ============================================================
    # TIMESTAMP
    # ============================================================

    created_at: Mapped[datetime] = mapped_column(
        nullable=False,
        default=datetime.utcnow,
    )

    # ============================================================
    # RELATIONSHIPS
    # ============================================================

    source_activity = relationship(
        "Activity",
        foreign_keys=[source_activity_id],
    )

    source_ai_opportunity = relationship(
        "AIOpportunity",
        foreign_keys=[source_ai_opportunity_id],
    )

    affected_activity = relationship(
        "Activity",
        foreign_keys=[affected_activity_id],
    )

    affected_role = relationship(
        "Role",
        foreign_keys=[affected_role_id],
    )

    affected_skill = relationship(
        "Skill",
        foreign_keys=[affected_skill_id],
    )