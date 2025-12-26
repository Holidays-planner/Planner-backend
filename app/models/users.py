from datetime import datetime
from models.base import db, BaseModel


class Users(BaseModel):
    __tablename__ = 'users'

    username = db.Column(db.String(255), unique=True, nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    first_name = db.Column(db.String(255))
    last_name = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    user_roles = db.relationship('UserRoles', backref='user', lazy=True, cascade='all, delete-orphan')
    user_settings = db.relationship('UserSetting', backref='user', lazy=True, cascade='all, delete-orphan')
    vacation_plans = db.relationship('VacationPlan', backref='owner', lazy=True, cascade='all, delete-orphan')

    def __repr__(self):
        return f'<User {self.username}>'