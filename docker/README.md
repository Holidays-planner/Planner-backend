# Docker Setup for Planner Backend

This folder contains Docker configuration for running PostgreSQL database for the Planner Backend application.

## Prerequisites

- Docker installed on your system
- Docker Compose installed (usually comes with Docker Desktop)

## Quick Start

### Using Docker Compose (Recommended)

1. Navigate to the docker folder:
   ```bash
   cd docker
   ```

2. Create your environment file with the database configuration:
   ```bash
   # Create .env file with your database settings
   echo "POSTGRES_DB=planner_db" > .env
   echo "POSTGRES_USER=planner_user" >> .env  
   echo "POSTGRES_PASSWORD=planner_password" >> .env
   ```

3. Start the PostgreSQL container:
   ```bash
   docker-compose up -d
   ```

4. Check if the container is running:
   ```bash
   docker-compose ps
   ```

5. View logs:
   ```bash
   docker-compose logs -f postgres
   ```

6. Stop the container:
   ```bash
   docker-compose down
   ```

7. Stop and remove all data (including volumes):
   ```bash
   docker-compose down -v
   ```

### Using Docker Build Directly

1. Build the Docker image:
   ```bash
   docker build -t planner-postgres -f docker/postgresDockerfile .
   ```

2. Run the container:
   ```bash
   docker run -d \
     --name planner-postgres \
     -e POSTGRES_DB=planner_db \
     -e POSTGRES_USER=planner_user \
     -e POSTGRES_PASSWORD=planner_password \
     -p 5432:5432 \
     -v postgres-data:/var/lib/postgresql/data \
     planner-postgres
   ```

## Database Connection

Once the container is running, you can connect to the PostgreSQL database using:

- **Host**: localhost
- **Port**: 5432
- **Database**: planner_db
- **Username**: planner_user
- **Password**: planner_password

### Connection String Example
```
postgresql://planner_user:planner_password@localhost:5432/planner_db
```

## Database Initialization

The database is automatically initialized with the SQL scripts from the `db/` folder:
- `01_Create_Tables.sql` - Creates all necessary tables and schema

These scripts are executed automatically when the container is first created.

## Environment Variables

The database configuration is managed through a `.env` file. Create the `.env` file with your database settings:

```bash
# Create .env file with database configuration
echo "POSTGRES_DB=planner_db" > .env
echo "POSTGRES_USER=planner_user" >> .env  
echo "POSTGRES_PASSWORD=planner_password" >> .env
```

Available environment variables:

- `POSTGRES_DB`: Name of the database (default: planner_db)
- `POSTGRES_USER`: Database user (default: planner_user)
- `POSTGRES_PASSWORD`: Database password (default: planner_password)

**Note**: The `.env` file is excluded from version control to protect sensitive credentials.

### Security Note

⚠️ **Important**: The default credentials provided in this setup are intended for **development purposes only**. 

For production environments:
- Use strong, unique passwords
- Consider using Docker secrets or external secret management systems
- Do not commit production credentials to version control
- Use environment files (.env) that are excluded from git (.gitignore)

## Troubleshooting

### Container won't start
- Check if port 5432 is already in use: `lsof -i :5432`
- View container logs: `docker-compose logs postgres`

### Database not initialized
- Remove the volume and recreate: `docker-compose down -v && docker-compose up -d`

### Permission issues
- Ensure the db folder has read permissions
- Check Docker has access to the project directory
