-- Procedure to create necessary tables
CREATE OR REPLACE PROCEDURE create_all_tables()
LANGUAGE plpgsql AS $$
BEGIN

    -- Create `roles` table
    CREATE TABLE IF NOT EXISTS roles (
        id SERIAL PRIMARY KEY,
        role_name VARCHAR(255) NOT NULL UNIQUE,
        description VARCHAR(500),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `actions` table for defining what operations can be performed and scopes
    CREATE TABLE IF NOT EXISTS actions (
        id SERIAL PRIMARY KEY,
        action_key VARCHAR(255) NOT NULL,
        scope VARCHAR(100) NOT NULL,
        action_name VARCHAR(255) NOT NULL,
        description VARCHAR(500),
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `role_actions` table for many-to-many relationship between roles and actions
    CREATE TABLE IF NOT EXISTS role_actions (
        id SERIAL PRIMARY KEY,
        role_id INT NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
        action_id INT NOT NULL REFERENCES actions(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (role_id, action_id)
    );

    -- Create `settings` table
    CREATE TABLE IF NOT EXISTS settings (
        id SERIAL PRIMARY KEY,
        setting_key VARCHAR(255) NOT NULL UNIQUE,
        setting_name VARCHAR(255) NOT NULL,
        setting_default_value TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `setting_options` table
    CREATE TABLE IF NOT EXISTS setting_options (
        id SERIAL PRIMARY KEY,
        setting_id INT REFERENCES settings(id) ON DELETE CASCADE,
        option_value VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (setting_id, option_value)
    );

    -- Create `users` table
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(255) NOT NULL UNIQUE,
        email VARCHAR(255) NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `user_roles` table
    CREATE TABLE IF NOT EXISTS user_roles (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(id) ON DELETE CASCADE,
        role_id INT REFERENCES roles(id) ON DELETE CASCADE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (user_id, role_id)
    );

    -- Create `user_settings` table
    CREATE TABLE IF NOT EXISTS user_settings (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users(id) ON DELETE CASCADE,
        setting_id INT REFERENCES settings(id) ON DELETE CASCADE,
        setting_value VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (user_id, setting_id)
    );

    CREATE TABLE IF NOT EXISTS friends (
        friendship_id SERIAL PRIMARY KEY,
        requestor_id INT REFERENCES users(id) ON DELETE CASCADE,
        addressee_id INT REFERENCES users(id) ON DELETE CASCADE,
        status VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (requestor_id, addressee_id)
    );

    -- Create `vacation_plans` table
    CREATE TABLE IF NOT EXISTS vacation_plans (
        id SERIAL PRIMARY KEY,
        user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        start_date DATE NOT NULL,
        end_date DATE NOT NULL,
        budget DECIMAL(10,2),
        status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'planned', 'in_progress', 'completed', 'cancelled')),
        is_public BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW(),
        CONSTRAINT valid_date_range CHECK (end_date >= start_date)
    );

    -- Create `vacation_destinations` table for multiple destinations per plan
    CREATE TABLE IF NOT EXISTS vacation_destinations (
        id SERIAL PRIMARY KEY,
        plan_id INT NOT NULL REFERENCES vacation_plans(id) ON DELETE CASCADE,
        destination_name VARCHAR(255) NOT NULL,
        country VARCHAR(100),
        city VARCHAR(100),
        arrival_date DATE,
        departure_date DATE,
        accommodation VARCHAR(255),
        notes TEXT,
        order_sequence INT NOT NULL DEFAULT 1,
        created_at TIMESTAMP DEFAULT NOW(),
        updated_at TIMESTAMP DEFAULT NOW()
    );

    -- Create `vacation_plan_participants` table for sharing plans with friends
    CREATE TABLE IF NOT EXISTS vacation_plan_participants (
        id SERIAL PRIMARY KEY,
        plan_id INT REFERENCES vacation_plans(id) ON DELETE CASCADE,
        user_id INT REFERENCES users(id) ON DELETE CASCADE,
        role_id INT REFERENCES roles(id) ON DELETE CASCADE,
        joined_at TIMESTAMP DEFAULT NOW(),
        UNIQUE (plan_id, user_id)
    );

    -- Notify that the procedure has completed
    RAISE NOTICE 'All tables created successfully.';
END;
$$;

CALL create_all_tables();
