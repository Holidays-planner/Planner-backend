from datetime import datetime
from app import db


class Setting(db.Model):
    __tablename__ = 'settings'

    setting_id = db.Column(db.Integer, primary_key=True)
    setting_key = db.Column(db.String(255), unique=True, nullable=False)
    setting_name = db.Column(db.String(255), nullable=False)
    setting_default_value = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    user_settings = db.relationship('UserSetting', backref='setting', lazy=True)
