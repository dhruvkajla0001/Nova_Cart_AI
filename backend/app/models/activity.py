from sqlalchemy import BigInteger, ForeignKey, Integer, Numeric, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Activity(Base):
    __tablename__ = "activities"

    activity_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    process_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("processes.process_id"),
        nullable=False,
    )

    activity_code: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
    )

    name: Mapped[str] = mapped_column(
        String(200),
        nullable=False,
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    activity_type: Mapped[str | None] = mapped_column(
        String(50),
        nullable=True,
    )

    automation_level: Mapped[float | None] = mapped_column(
        Numeric(5, 2),
        nullable=True,
    )

    sequence_order: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=0,
    )

    process = relationship(
        "Process",
        back_populates="activities",
    )