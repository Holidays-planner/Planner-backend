from sqlalchemy.ext.declarative import declared_attr
from run import db


class BaseModel(db.Model):
    __abstract__ = True

    @declared_attr
    def __tablename__(self):
        return self.__name__.lower()

    id = db.Column(db.Integer, primary_key=True)

    def save(self):
        if not self.id:
            db.session.add(self)
        db.session.commit()

    def to_json(self) -> dict:
        obj = {
            "id": self.id
        }
        return obj

    @classmethod
    def count_rows(cls):
        return cls.query.count()