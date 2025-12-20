-- SQL script to create tables for managing users, settings, and allowed values

-- SQL script to create tables for Role-Based Access Control (RBAC)

-- 1. Create `roles` table - defines various roles in the system (e.g., admin, user)
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,             -- Unique identifier for each role
    role_name VARCHAR(255) NOT NULL UNIQUE, -- Name of the role, e.g., 'admin', 'user'
    created_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of role creation
    updated_at TIMESTAMP DEFAULT NOW()      -- Timestamp of last update
);

-- 2. Create `permissions` table - defines permissions available in the system
CREATE TABLE permissions (
    permission_id SERIAL PRIMARY KEY,        -- Unique identifier for each permission
    permission_key VARCHAR(255) NOT NULL UNIQUE, -- Permission name/key, e.g., 'edit_user_settings'
    description TEXT,                        -- Description of what the permission entails
    created_at TIMESTAMP DEFAULT NOW(),      -- Timestamp of permission creation
    updated_at TIMESTAMP DEFAULT NOW()       -- Timestamp of last update
);

-- 3. Create `roles_permissions` table - maps roles to their allowed permissions
CREATE TABLE roles_permissions (
    id SERIAL PRIMARY KEY,                  -- Unique ID for each role-permission association
    role_id INT REFERENCES roles(role_id) ON DELETE CASCADE, -- Role that gets the permission
    permission_id INT REFERENCES permissions(permission_id) ON DELETE CASCADE, -- Permission assigned to the role
    created_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of creation
    updated_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of last update
    UNIQUE (role_id, permission_id)         -- Ensure a role cannot have the same permission assigned multiple times
);

-- 4. Create `users` table - defines users in the system
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,             -- Unique identifier for each user
    username VARCHAR(255) NOT NULL UNIQUE,   -- Unique username
    email VARCHAR(255) NOT NULL UNIQUE,     -- User's email address
    password_hash TEXT NOT NULL,            -- Encrypted password hash
    created_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of user creation
    updated_at TIMESTAMP DEFAULT NOW()      -- Timestamp of last user update
);

-- 5. Create `user_roles` table - maps users to their assigned roles
CREATE TABLE user_roles (
    id SERIAL PRIMARY KEY,                  -- Unique ID for each user-role association
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE, -- User assigned to the role
    role_id INT REFERENCES roles(role_id) ON DELETE CASCADE, -- Role assigned to the user
    created_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of role assignment
    updated_at TIMESTAMP DEFAULT NOW(),     -- Timestamp of last update
    UNIQUE (user_id, role_id)               -- Ensure a user cannot have the same role multiple times
);

-- 6. Create `settings` table - defines the general settings
CREATE TABLE settings (
    setting_id SERIAL PRIMARY KEY,            -- Unique identifier for each setting
    setting_key VARCHAR(255) NOT NULL UNIQUE, -- Global name of the setting, e.g., "theme"
    setting_default_value TEXT NOT NULL,      -- Default value for the setting
    created_at TIMESTAMP DEFAULT NOW(),       -- Timestamp of creation
    updated_at TIMESTAMP DEFAULT NOW()        -- Timestamp of last update
);

-- 7. Create `setting_options` table - specifies allowed values for each setting
CREATE TABLE setting_options (
    option_id SERIAL PRIMARY KEY,             -- Unique identifier for each allowed value
    setting_id INT REFERENCES settings(setting_id) ON DELETE CASCADE, -- Reference to the `settings` table
    option_value VARCHAR(255) NOT NULL,       -- Allowed value for the setting, e.g., "light", "dark"
    created_at TIMESTAMP DEFAULT NOW(),       -- Timestamp of creation
    updated_at TIMESTAMP DEFAULT NOW(),       -- Timestamp of last update
    UNIQUE (setting_id, option_value)         -- Ensure each value is unique per setting
);

-- 8. Create `user_settings` table - maps users to their specific settings
CREATE TABLE user_settings (
    id SERIAL PRIMARY KEY,                    -- Unique ID for each user-setting combination
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE, -- Foreign key to `users`
    setting_id INT REFERENCES settings(setting_id) ON DELETE CASCADE, -- Foreign key to `settings`
    option_id INT REFERENCES setting_options(option_id) ON DELETE CASCADE, -- Foreign key to selected option
    created_at TIMESTAMP DEFAULT NOW(),       -- Timestamp of creation
    updated_at TIMESTAMP DEFAULT NOW(),       -- Timestamp of last update
    UNIQUE (user_id, setting_id)              -- Each user can only have one value per setting
);

-- Script ends here