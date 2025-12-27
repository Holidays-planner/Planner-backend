from models.base import db, BaseModel


class RoleActions(BaseModel):
    __tablename__ = 'roles_actions'

    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)
    action_id = db.Column(db.Integer, db.ForeignKey('actions.id'), nullable=False)

    __table_args__ = (db.UniqueConstraint('role_id', 'action_id', name='unique_role_permission'),)