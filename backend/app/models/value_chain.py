from sqlalchemy import BigInteger, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class ValueChain(Base):
    __tablename__ = "value_chains"

    value_chain_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    industry_id: Mapped[int] = mapped_column(
        BigInteger,
        ForeignKey("industries.industry_id"),
        nullable=False,
    )

    value_chain_code: Mapped[str] = mapped_column(
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

    industry = relationship(
        "Industry",
        back_populates="value_chains",
    )

    processes = relationship(
        "Process",
        back_populates="value_chain",
        cascade="all, delete-orphan",
    )