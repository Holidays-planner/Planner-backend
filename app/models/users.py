from datetime import datetime
from models.base import db, BaseModel
from run import bcrypt


class Users(BaseModel):
    __tablename__ = 'users'

    username = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    status = db.Column(db.String(50), nullable=False, default='pending')  # pending, active, suspended
    created_at = db.Column(db.DateTime)
    updated_at = db.Column(db.DateTime)

    # Relationships
    user_roles = db.relationship('UserRoles', backref='user', lazy=True, cascade='all, delete-orphan')
    user_settings = db.relationship('UserSetting', backref='user', lazy=True, cascade='all, delete-orphan')
    vacation_plans = db.relationship('VacationPlan', backref='owner', lazy=True, cascade='all, delete-orphan')

    def __init__(self, **kwargs):
        self.username = kwargs.get('username')
        self.email = kwargs.get('email')
        self.password_hash = bcrypt.generate_password_hash(kwargs.get("password")).decode('utf-8')

        self.status = kwargs.get('status', 'pending')

    def __repr__(self):
        return f'<User {self.username}>'