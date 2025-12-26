import os

from run import app, api
from routes.users import users_ns
from routes.auth import auth_ns

api.add_namespace(users_ns, path='/users')
api.add_namespace(auth_ns, path='/auth')
# Health check endpoint
@app.route('/health')
def health_check():
    return {'status': 'healthy', 'message': 'Planner API is running'}

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return {'error': 'Resource not found'}, 404

@app.errorhandler(400)
def bad_request(error):
    return {'error': 'Bad request'}, 400

@app.errorhandler(500)
def internal_error(error):
    return {'error': 'Internal server error'}, 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=False, host='localhost', port=port)
