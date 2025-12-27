
from flask_restx import Namespace, Resource, fields

from models import Users
from utils.security import jwt_required_restx

# Create namespace
auth_ns = Namespace('auth', description='Authentication operations')

# Define models for documentation
register_model = auth_ns.model('Register', {
    'username': fields.String(required=True, description='Username', nullable=False),
    'email': fields.String(required=True, description='Email address', nullable=False),
    'password': fields.String(required=True, description='Password', nullable=False),
    'first_name': fields.String(required=True, description='First name', nullable=False),
    'last_name': fields.String(required=True, description='Last name', nullable=False)
})

login_model = auth_ns.model('Login', {
    'email': fields.String(required=True, description='Email address'),
    'password': fields.String(required=True, description='Password')
})

token_response = auth_ns.model('TokenResponse', {
    'access_token': fields.String(description='JWT access token'),
    'refresh_token': fields.String(description='JWT refresh token')
})

@auth_ns.route('/register')
class Register(Resource):
    @auth_ns.expect(register_model, validate=True)
    @auth_ns.marshal_with(register_model, code=201)
    def post(self):
        """Register a new user (Public endpoint)"""
        # Your registration logic here
        return {}, 201

@auth_ns.route('/login')
class Login(Resource):
    @auth_ns.expect(login_model)
    @auth_ns.marshal_with(token_response)
    def post(self):
        """Login and get JWT tokens (Public endpoint)"""
        # Your login logic here
        # Example: 
        # access_token = create_access_token(identity=user_id)
        # refresh_token = create_refresh_token(identity=user_id)
        return {'access_token': 'token', 'refresh_token': 'refresh'}, 200