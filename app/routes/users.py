
from flask_restx import Namespace, Resource, fields
from flask_jwt_extended import jwt_required
# Create namespace
users_ns = Namespace('users', description='User operations')

# Define models for documentation
user_model = users_ns.model('User', {
    'id': fields.Integer(description='User ID'),
    'username': fields.String(required=True, description='Username'),
    'email': fields.String(required=True, description='Email address')
})

@users_ns.route('/')
class UserList(Resource):
    @jwt_required()
    def get(self):
        """Get all users"""
        # Your logic here
        return []
