from datetime import datetime
from app import db

class VacationPlanParticipant(db.Model):
    __tablename__ = 'vacation_plan_participants'

    participant_id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('vacation_plans.plan_id'), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    role = db.Column(db.String(50), default='participant')  # owner, co_planner, participant
    joined_at = db.Column(db.DateTime, default=datetime.now())

    # Relationships
    participant = db.relationship('User', backref='vacation_participations')

    __table_args__ = (db.UniqueConstraint('plan_id', 'user_id', name='unique_plan_participant'),)
