from sqlalchemy import BigInteger, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Process(Base):
    __tablename__ = "processes"

    process_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    value_chain_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("value_chains.value_chain_id"),
        nullable=False,
    )

    process_code: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
    )

    name: Mapped[str] = mapped_column(
        String(150),
        nullable=False,
    )

    description: Mapped[str | None] = mapped_column(
        Text,
        nullable=True,
    )

    sequence_order: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        default=0,
    )

    value_chain = relationship(
        "ValueChain",
        back_populates="processes",
    )

    activities = relationship(
        "Activity",
        back_populates="process",
        cascade="all, delete-orphan",
    )