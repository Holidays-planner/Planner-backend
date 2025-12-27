from run import db


class BaseModel(db.Model):
    __abstract__ = True

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)

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