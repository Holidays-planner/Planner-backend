# Use official PostgreSQL image as base
FROM postgres:16-alpine

# Copy initialization scripts to the container
# PostgreSQL will automatically run any .sql or .sh scripts in /docker-entrypoint-initdb.d/
COPY db/*.sql /docker-entrypoint-initdb.d/

# Expose PostgreSQL default port
EXPOSE 5432

# The postgres image already has the default CMD to start PostgreSQL
