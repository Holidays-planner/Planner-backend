# Planner Backend API

A comprehensive REST API built with Flask for vacation planning and social collaboration.

## Features

- **User Authentication**: Registration, login, JWT-based authentication
- **User Management**: Profile management, user search
- **Social Features**: Friend requests, friend management
- **Vacation Planning**: Create and manage multi-destination vacation plans
- **Collaboration**: Share vacation plans with friends, role-based permissions
- **Database**: PostgreSQL with SQLAlchemy ORM
- **Security**: Password hashing, JWT tokens, CORS support

## Quick Start

### Prerequisites

- Python 3.8+
- PostgreSQL 12+
- pip (Python package manager)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Planner-backend
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   # Windows
   venv\Scripts\activate
   # macOS/Linux
   source venv/bin/activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Setup database**
   ```bash
   # Create PostgreSQL database
   createdb planner_db
   
   # Run database scripts in order
   psql -d planner_db -f db/01_Create_Tables.sql
   psql -d planner_db -f db/02_Insert_Master_Data.sql
   psql -d planner_db -f db/03_RBAC_Sample_Data.sql
   psql -d planner_db -f db/04_RBAC_Views_Functions.sql
   ```

5. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

6. **Run the application**
   ```bash
   python run.py
   ```

The API will be available at `http://localhost:5000`

## API Endpoints

### Authentication

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123",
  "first_name": "John",
  "last_name": "Doe"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "username": "johndoe",
  "password": "password123"
}
```

#### Get Profile
```http
GET /api/auth/profile
Authorization: Bearer <access_token>
```

#### Update Profile
```http
PUT /api/auth/profile
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "first_name": "John",
  "last_name": "Smith",
  "email": "john.smith@example.com"
}
```

### Users

#### Get All Users
```http
GET /api/users?page=1&per_page=20
Authorization: Bearer <access_token>
```

#### Search Users
```http
POST /api/users/search
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "query": "john"
}
```

#### Get User by ID
```http
GET /api/users/{user_id}
Authorization: Bearer <access_token>
```

### Friends

#### Send Friend Request
```http
POST /api/friends/requests
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "addressee_id": 2
}
```

#### Respond to Friend Request
```http
POST /api/friends/requests/respond
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "friendship_id": 1,
  "action": "accept"  // accept, decline, block
}
```

#### Get Friends
```http
GET /api/friends
Authorization: Bearer <access_token>
```

#### Get Pending Requests
```http
GET /api/friends/requests/pending
Authorization: Bearer <access_token>
```

#### Remove Friend
```http
DELETE /api/friends/{friendship_id}
Authorization: Bearer <access_token>
```

### Vacation Plans

#### Create Vacation Plan
```http
POST /api/vacation-plans
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "title": "Europe Summer Trip",
  "description": "Amazing summer vacation across Europe",
  "start_date": "2025-07-01",
  "end_date": "2025-07-15",
  "budget": 5000.00,
  "status": "draft",
  "is_public": false
}
```

#### Get Vacation Plans
```http
GET /api/vacation-plans
Authorization: Bearer <access_token>
```

#### Get Vacation Plan Details
```http
GET /api/vacation-plans/{plan_id}
Authorization: Bearer <access_token>
```

#### Update Vacation Plan
```http
PUT /api/vacation-plans/{plan_id}
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "title": "Updated Europe Trip",
  "description": "Updated description",
  "start_date": "2025-07-01",
  "end_date": "2025-07-20",
  "budget": 6000.00,
  "status": "planned"
}
```

#### Add Destination
```http
POST /api/vacation-plans/{plan_id}/destinations
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "destination_name": "Paris",
  "country": "France",
  "city": "Paris",
  "arrival_date": "2025-07-01",
  "departure_date": "2025-07-05",
  "accommodation": "Hotel Paris Center",
  "notes": "Visit Eiffel Tower",
  "order_sequence": 1
}
```

#### Add Participant
```http
POST /api/vacation-plans/{plan_id}/participants
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "user_id": 2,
  "role": "co_planner"  // owner, co_planner, participant
}
```

#### Delete Vacation Plan
```http
DELETE /api/vacation-plans/{plan_id}
Authorization: Bearer <access_token>
```

## Database Schema

The application uses PostgreSQL with the following main tables:

- **users**: User accounts and profiles
- **roles**: User roles for permissions
- **permissions**: Available permissions
- **friends**: Friend relationships and requests
- **vacation_plans**: Vacation plan details
- **vacation_destinations**: Multiple destinations per plan
- **vacation_plan_participants**: Plan collaboration

For detailed schema information, see `db/README_RBAC.md`.

## Development

### Project Structure
```
Planner-backend/
├── app/
│   ├── app.py              # Flask application factory
│   ├── models.py           # SQLAlchemy database models
│   └── routes/             # API route handlers
│       ├── auth.py         # Authentication endpoints
│       ├── users.py        # User management endpoints
│       ├── friends.py      # Friend management endpoints
│       └── vacation_plans.py # Vacation planning endpoints
├── db/                     # Database scripts and documentation
├── docker/                 # Docker configuration
├── requirements.txt        # Python dependencies
├── run.py                  # Application entry point
└── README.md              # This file
```

### Key Dependencies

- **Flask**: Web framework
- **SQLAlchemy**: ORM for database operations
- **JWT**: Token-based authentication
- **Marshmallow**: Request/response validation
- **psycopg2**: PostgreSQL adapter
- **Flask-CORS**: Cross-origin resource sharing

### Error Handling

The API returns JSON error responses with appropriate HTTP status codes:

- `400`: Bad Request (validation errors)
- `401`: Unauthorized (authentication required)
- `403`: Forbidden (insufficient permissions)
- `404`: Not Found (resource doesn't exist)
- `500`: Internal Server Error

### Security Features

- Password hashing with bcrypt
- JWT token authentication
- CORS protection
- SQL injection prevention via SQLAlchemy ORM
- Input validation with Marshmallow

## Docker Support

Use the provided Docker configuration in the `docker/` directory for containerized deployment.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

