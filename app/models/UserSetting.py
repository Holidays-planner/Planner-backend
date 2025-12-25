from datetime import datetime
from app import db

class UserSetting(db.Model):
    __tablename__ = 'user_settings'

    user_setting_id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    setting_id = db.Column(db.Integer, db.ForeignKey('settings.setting_id'), nullable=False)
    setting_value = db.Column(db.String(255))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    __table_args__ = (db.UniqueConstraint('user_id', 'setting_id', name='unique_user_setting'),)