from datetime import datetime
from models.base import db, BaseModel

class UserRoles(BaseModel):
    __tablename__ = 'user_roles'

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now())

    __table_args__ = (db.UniqueConstraint('user_id', 'role_id', name='unique_user_role'),)