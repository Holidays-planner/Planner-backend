from functools import wraps
from flask_jwt_extended import verify_jwt_in_request, get_jwt_identity
from flask_restx import abort

def jwt_required_restx(fn):
    """
    Decorator to protect Flask-RESTX endpoints with JWT authentication
    """
    @wraps(fn)
    def wrapper(*args, **kwargs):
        try:
            verify_jwt_in_request()
            return fn(*args, **kwargs)
        except Exception as e:
            abort(401, f'Authentication required: {str(e)}')
    return wrapper

def admin_required(fn):
    """
    Decorator to ensure user has admin privileges
    """
    @wraps(fn)
    def wrapper(*args, **kwargs):
        try:
            verify_jwt_in_request()
            current_user = get_jwt_identity()
            # Add your admin check logic here
            # Example: if not current_user.get('is_admin'):
            #     abort(403, 'Admin access required')
            return fn(*args, **kwargs)
        except Exception as e:
            abort(403, f'Admin access required: {str(e)}')
    return wrapper