# Database Scripts

This directory contains SQL scripts for setting up and managing the Planner backend database.

## Files

### 01_Create_Tables.sql
Creates the database schema with the following tables:
- `roles` - System roles (e.g., admin, user)
- `permissions` - System permissions
- `roles_permissions` - Role-to-permission mappings
- `users` - User accounts
- `user_roles` - User-to-role assignments
- `settings` - Global settings
- `setting_options` - Allowed values for settings
- `user_settings` - User-specific settings

### 02_Create_Procedures.sql
Creates stored procedures for database operations. All procedures use PostgreSQL's `plpgsql` language.

## Stored Procedures

### Role Management
- **`create_role(p_role_name)`** - Create a new role
- **`update_role(p_role_id, p_role_name)`** - Update an existing role
- **`delete_role(p_role_id)`** - Delete a role

### Permission Management
- **`create_permission(p_permission_key, p_description)`** - Create a new permission
- **`update_permission(p_permission_id, p_permission_key, p_description)`** - Update a permission
- **`delete_permission(p_permission_id)`** - Delete a permission

### Role-Permission Assignments
- **`assign_permission_to_role(p_role_id, p_permission_id)`** - Grant a permission to a role
- **`remove_permission_from_role(p_role_id, p_permission_id)`** - Revoke a permission from a role

### User Management
- **`create_user(p_username, p_email, p_password_hash)`** - Create a new user
- **`update_user(p_user_id, p_username, p_email, p_password_hash)`** - Update user details
- **`delete_user(p_user_id)`** - Delete a user

### User-Role Assignments
- **`assign_role_to_user(p_user_id, p_role_id)`** - Assign a role to a user
- **`remove_role_from_user(p_user_id, p_role_id)`** - Remove a role from a user

### Settings Management
- **`create_setting(p_setting_key, p_setting_default_value)`** - Create a new setting
- **`update_setting(p_setting_id, p_setting_key, p_setting_default_value)`** - Update a setting
- **`delete_setting(p_setting_id)`** - Delete a setting

### Setting Options
- **`add_setting_option(p_setting_id, p_option_value)`** - Add an allowed value for a setting
- **`remove_setting_option(p_option_id)`** - Remove a setting option

### User Settings
- **`set_user_setting(p_user_id, p_setting_id, p_option_id)`** - Set a user's setting with a specific option value
- **`remove_user_setting(p_user_id, p_setting_id)`** - Remove a user's setting

## Usage

### Setup Database
To set up the database, execute the scripts in order:

```bash
# Create tables
psql -d your_database -f 01_Create_Tables.sql

# Create stored procedures
psql -d your_database -f 02_Create_Procedures.sql
```

### Using Stored Procedures

Stored procedures are called using the `CALL` statement:

```sql
-- Create a new role
CALL create_role('administrator');

-- Create a new user
CALL create_user('john_doe', 'john@example.com', 'hashed_password_here');

-- Assign a role to a user
CALL assign_role_to_user(1, 1);

-- Create a permission
CALL create_permission('edit_users', 'Permission to edit user accounts');

-- Assign permission to role
CALL assign_permission_to_role(1, 1);

-- Create a setting
CALL create_setting('theme', 'light');

-- Add setting options
CALL add_setting_option(1, 'light');
CALL add_setting_option(1, 'dark');

-- Set user setting (assuming option_id 1 is 'light')
CALL set_user_setting(1, 1, 1);
```

## Notes

- All procedures include automatic timestamp updates via `updated_at` fields
- Unique constraint violations are handled gracefully using `ON CONFLICT` clauses
- Foreign key cascades ensure referential integrity
- Optional parameters use PostgreSQL's `COALESCE` function for flexibility
