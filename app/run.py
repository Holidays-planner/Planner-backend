from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from werkzeug.utils import import_string
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_bcrypt import Bcrypt
from flask_wtf.csrf import CSRFProtect
from flask_restx import Api

app = Flask(__name__)
cfg = import_string(f"utils.config.Config")()
app.config.from_object(cfg)

# Initialize extensions
db = SQLAlchemy(app)
jwt = JWTManager(app)
bcrypt = Bcrypt(app)
csrf = CSRFProtect(app)
CORS(app, resources={r"/*": {"origins": "*", "send_wildcard": "False"}})

api = Api(
    app,
    version='1.0',
    title='Planner API',
    description='A simple Planner API with Swagger documentation',
    doc='/swagger/'  # Swagger UI will be available at /swagger/
)

