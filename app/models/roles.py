from datetime import datetime
from models.base import db, BaseModel


class Roles(BaseModel):
    __tablename__ = 'roles'

    role_name = db.Column(db.String(255), unique=True, nullable=False)
    description = db.Column(db.String(500))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    role_actions = db.relationship('RoleActions', backref='role', lazy=True, cascade='all, delete-orphan')