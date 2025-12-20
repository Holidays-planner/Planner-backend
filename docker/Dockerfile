# Use official PostgreSQL image as base
FROM postgres:16-alpine

# Set environment variables for PostgreSQL
ENV POSTGRES_DB=planner_db
ENV POSTGRES_USER=planner_user
ENV POSTGRES_PASSWORD=planner_password

# Copy initialization scripts to the container
# PostgreSQL will automatically run any .sql or .sh scripts in /docker-entrypoint-initdb.d/
COPY db/*.sql /docker-entrypoint-initdb.d/

# Expose PostgreSQL default port
EXPOSE 5432

# The postgres image already has the default CMD to start PostgreSQL
