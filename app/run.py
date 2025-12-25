from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from werkzeug.utils import import_string


app = Flask(__name__)
cfg = import_string(f"utils.config.Config")()
app.config.from_object(cfg)

db = SQLAlchemy(app)