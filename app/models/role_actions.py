from datetime import datetime
from models.base import db, BaseModel


class RoleActions(BaseModel):
    __tablename__ = 'roles_actions'

    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)
    action_id = db.Column(db.Integer, db.ForeignKey('actions.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    __table_args__ = (db.UniqueConstraint('role_id', 'action_id', name='unique_role_permission'),)