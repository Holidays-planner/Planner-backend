from datetime import datetime
from models.base import db, BaseModel

class VacationPlanParticipant(BaseModel):
    __tablename__ = 'vacation_plan_participants'

    plan_id = db.Column(db.Integer, db.ForeignKey('vacation_plans.id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'), nullable=False)  # owner, co_planner, participant
    joined_at = db.Column(db.DateTime, default=datetime.now())

    # Relationships
    participant = db.relationship('Users', backref='vacation_participations')

    __table_args__ = (db.UniqueConstraint('plan_id', 'user_id', name='unique_plan_participant'),)
