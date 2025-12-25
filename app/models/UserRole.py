from datetime import datetime
from app import db

class UserRole(db.Model):
    __tablename__ = 'user_roles'

    user_role_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.role_id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now())

    __table_args__ = (db.UniqueConstraint('user_id', 'role_id', name='unique_user_role'),)