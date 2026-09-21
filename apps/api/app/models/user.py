import uuid
from datetime import datetime

from sqlalchemy import DateTime, String, func
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base


class User(Base):
    """App-side record for a learner. Identity itself lives in AWS Cognito."""

    __tablename__ = "users"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, default=uuid.uuid4)

    # Cognito's `sub` claim. Deliberately no email or password column: credentials and
    # contact details stay in Cognito so this database never becomes a PII target.
    cognito_sub: Mapped[str] = mapped_column(String(64), unique=True, index=True)

    display_name: Mapped[str] = mapped_column(String(50))
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())
