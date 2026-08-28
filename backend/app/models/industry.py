from sqlalchemy import BigInteger, String, Text
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.db.database import Base


class Industry(Base):
    __tablename__ = "industries"

    industry_id: Mapped[int] = mapped_column(
        BigInteger,
        primary_key=True,
    )

    industry_code: Mapped[str] = mapped_column(
        String(50),
        unique=True,
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

    value_chains = relationship(
        "ValueChain",
        back_populates="industry",
        cascade="all, delete-orphan",
    )