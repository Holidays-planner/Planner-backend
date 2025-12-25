from datetime import datetime
from run import db

class Friend(db.Model):
    __tablename__ = 'friends'

    friendship_id = db.Column(db.Integer, primary_key=True)
    requestor_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    addressee_id = db.Column(db.Integer, db.ForeignKey('users.user_id'), nullable=False)
    status = db.Column(db.String(50), nullable=False)  # pending, accepted, declined, blocked
    created_at = db.Column(db.DateTime, default=datetime.now())
    updated_at = db.Column(db.DateTime, default=datetime.now(), onupdate=datetime.now())

    # Relationships
    requestor = db.relationship('User', foreign_keys=[requestor_id], backref='sent_friend_requests')
    addressee = db.relationship('User', foreign_keys=[addressee_id], backref='received_friend_requests')

    __table_args__ = (db.UniqueConstraint('requestor_id', 'addressee_id', name='unique_friendship'),)