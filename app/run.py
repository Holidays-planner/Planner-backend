from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from werkzeug.utils import import_string
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt

app = Flask(__name__)
cfg = import_string(f"utils.config.Config")()
app.config.from_object(cfg)

# Initialize extensions
db = SQLAlchemy(app)
jwt = JWTManager(app)
bcrypt = Bcrypt(app)

CORS(app)

