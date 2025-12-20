-- Procedure to create necessary tables
CREATE OR REPLACE PROCEDURE create_all_tables()
LANGUAGE plpgsql AS $$
BEGIN
    -- Create `roles` table
    CREATE TABLE IF NOT EXISTS roles (
        role_id SERIAL PRIMARY KEY,
        role_name VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `permissions` table
    CREATE TABLE IF NOT EXISTS permissions (
        permission_id SERIAL PRIMARY KEY,
        permission_key VARCHAR(255) NOT NULL UNIQUE,
        description TEXT,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `roles_permissions` table
    CREATE TABLE IF NOT EXISTS roles_permissions (
        id SERIAL PRIMARY KEY,
        role_id INT REFERENCES roles(role_id) ON DELETE CASCADE,
        permission_id INT REFERENCES permissions(permission_id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (role_id, permission_id)
    );

    -- Create `users` table
    CREATE TABLE IF NOT EXISTS users (
        user_id SERIAL PRIMARY KEY,
        username VARCHAR(255) NOT NULL UNIQUE,
        email VARCHAR(255) NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `user_roles` table
    CREATE TABLE IF NOT EXISTS user_roles (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
        role_id INT REFERENCES roles(role_id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (user_id, role_id)
    );

    -- Create `settings` table
    CREATE TABLE IF NOT EXISTS settings (
        setting_id SERIAL PRIMARY KEY,
        setting_key VARCHAR(255) NOT NULL UNIQUE,
        setting_default_value TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `setting_options` table
    CREATE TABLE IF NOT EXISTS setting_options (
        option_id SERIAL PRIMARY KEY,
        setting_id INT REFERENCES settings(setting_id) ON DELETE CASCADE,
        option_value VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (setting_id, option_value)
    );

    -- Create `user_settings` table
    CREATE TABLE IF NOT EXISTS user_settings (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
        setting_id INT REFERENCES settings(setting_id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (user_id, setting_id)
    );

    -- Notify that the procedure has completed
    RAISE NOTICE 'All tables created successfully.';
END;
$$;

CALL create_all_tables();
