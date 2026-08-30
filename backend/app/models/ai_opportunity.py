from __future__ import annotations

from datetime import datetime

from sqlalchemy import BigInteger, ForeignKey, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class AIOpportunity(Base):
    __tablename__ = "ai_opportunities"

    ai_opportunity_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    activity_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey(
            "activities.activity_id",
            ondelete="CASCADE",
        ),
        nullable=False,
    )

    name: Mapped[str] = mapped_column(
        String(200),
        nullable=False,
    )

    description: Mapped[str] = mapped_column(
        Text,
        nullable=False,
    )

    ai_type: Mapped[str | None] = mapped_column(
        String(100),
        nullable=True,
    )

    technology: Mapped[str | None] = mapped_column(
        String(150),
        nullable=True,
    )

    automation_score: Mapped[float | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    augmentation_score: Mapped[float | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    confidence_score: Mapped[float | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    status: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        default="identified",
    )

    created_at: Mapped[datetime] = mapped_column(
        nullable=False,
        default=datetime.utcnow,
    )

    updated_at: Mapped[datetime] = mapped_column(
        nullable=False,
        default=datetime.utcnow,
        onupdate=datetime.utcnow,
    )

    activity = relationship(
        "Activity",
        back_populates="ai_opportunities",
    )