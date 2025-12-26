
from flask_restx import Namespace, Resource, fields

# Create namespace
auth_ns = Namespace('auth', description='Authentication operations')

# Define models for documentation
register_model = auth_ns.model('Register', {
    'username': fields.String(required=True, description='Username'),
    'email': fields.String(required=True, description='Email address'),
    'password': fields.String(required=True, description='Password'),
    'first_name': fields.String(required=True, description='First name'),
    'last_name': fields.String(required=True, description='Last name')
})

@auth_ns.route('/register')
class Register(Resource):
    @auth_ns.expect(register_model)
    @auth_ns.marshal_with(register_model, code=201)
    def post(self):
        """Register a new user"""
        # Your registration logic here
        return {}, 201