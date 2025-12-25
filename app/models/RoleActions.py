from datetime import datetime
from run import db


class RoleActions(db.Model):
    __tablename__ = 'roles_actions'

    role_permission_id = db.Column(db.Integer, primary_key=True)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.role_id'), nullable=False)
    permission_id = db.Column(db.Integer, db.ForeignKey('permissions.permission_id'), nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.now())

    __table_args__ = (db.UniqueConstraint('role_id', 'permission_id', name='unique_role_permission'),)