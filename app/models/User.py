from datetime import datetime
from app import db

class User(db.Model):
    __tablename__ = 'users'

    user_id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=True, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    first_name = db.Column(db.String(255))
    last_name = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    user_roles = db.relationship('UserRole', backref='user', lazy=True, cascade='all, delete-orphan')
    user_settings = db.relationship('UserSetting', backref='user', lazy=True, cascade='all, delete-orphan')
    vacation_plans = db.relationship('VacationPlan', backref='owner', lazy=True, cascade='all, delete-orphan')

    def __repr__(self):
        return f'<User {self.username}>'