from datetime import datetime
from base import db, BaseModel


class Actions(BaseModel):
    action_key = db.Column(db.String(255), nullable=False)
    scope = db.Column(db.String(100), unique=True, nullable=False)
    action_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())