from datetime import datetime
from app import db

class VacationDestination(db.Model):
    __tablename__ = 'vacation_destinations'

    destination_id = db.Column(db.Integer, primary_key=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('vacation_plans.plan_id'), nullable=False)
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
