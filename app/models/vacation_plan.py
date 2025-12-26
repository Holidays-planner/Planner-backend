from datetime import datetime
from models.base import db, BaseModel

class VacationPlan(BaseModel):
    __tablename__ = 'vacation_plans'

    user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    title = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    start_date = db.Column(db.Date, nullable=False)
    end_date = db.Column(db.Date, nullable=False)
    budget = db.Column(db.Numeric(10, 2))
    status = db.Column(db.String(50), default='draft')
    is_public = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    destinations = db.relationship('VacationDestination', backref='vacation_plan', lazy=True, cascade='all, delete-orphan')
    participants = db.relationship('VacationPlanParticipant', backref='vacation_plan', lazy=True, cascade='all, delete-orphan')

    # Check constraint equivalent
    __table_args__ = (db.CheckConstraint('end_date >= start_date', name='valid_date_range'),)
