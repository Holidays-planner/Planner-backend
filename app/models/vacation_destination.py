from datetime import datetime
from models.base import db, BaseModel

class VacationDestination(BaseModel):
    __tablename__ = 'vacation_destinations'

    plan_id = db.Column(db.Integer, db.ForeignKey('vacation_plans.id'), nullable=False)
    destination_name = db.Column(db.String(255), nullable=False)
    country = db.Column(db.String(100))
    city = db.Column(db.String(100))
    arrival_date = db.Column(db.Date)
    departure_date = db.Column(db.Date)
    accommodation = db.Column(db.String(255))
    notes = db.Column(db.Text)
    order_sequence = db.Column(db.Integer, nullable=False, default=1)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
