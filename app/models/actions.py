from datetime import datetime
from models.base import db, BaseModel


class Actions(BaseModel):
    __tablename__ = 'actions'
    action_key = db.Column(db.String(255), nullable=False)
    scope = db.Column(db.String(100), nullable=False)
    action_name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.String(500))
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    @property
    def scope_action(self):
        return f"{self.scope}:{self.action_key}"