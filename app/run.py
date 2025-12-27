from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from werkzeug.utils import import_string
from flask_cors import CORS
from flask_jwt_extended import JWTManager
import yaml
from logging.config import dictConfig
from flask_bcrypt import Bcrypt
from flask_restx import Api

with open("./logging.yaml", "r") as yaml_file:
    logging_data = yaml.safe_load(yaml_file)
    dictConfig(logging_data)

app = Flask(__name__)
cfg = import_string(f"utils.config.Config")()
app.config.from_object(cfg)

# Initialize extensions
db = SQLAlchemy(app)
jwt = JWTManager(app)
bcrypt = Bcrypt(app)
CORS(app, resources={r"/*": {"origins": "*", "send_wildcard": "False"}})

# Define authorization for Swagger
authorizations = {
    'Bearer Auth': {
        'type': 'apiKey',
        'in': 'header',
        'name': 'Authorization',
        'description': "Type in the *'Value'* input box below:  **'Bearer &lt;JWT&gt;'**, where JWT is the token"
    }
}

api = Api(
    app,
    version='1.0',
    title='Planner API',
    description='A simple Planner API with Swagger documentation',
    doc='/',  # Swagger UI will be available at /swagger/
    authorizations=authorizations # Apply to all endpoints by default
)
