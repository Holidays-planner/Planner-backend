-- SQL script to create stored procedures for managing users, settings, and RBAC

-- =============================================================================
-- ROLE MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to create a new role
CREATE OR REPLACE PROCEDURE create_role(
    p_role_name VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO roles (role_name)
    VALUES (p_role_name);
END;
$$;

-- Procedure to update a role
CREATE OR REPLACE PROCEDURE update_role(
    p_role_id INT,
    p_role_name VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE roles
    SET role_name = p_role_name,
        updated_at = NOW()
    WHERE role_id = p_role_id;
END;
$$;

-- Procedure to delete a role
CREATE OR REPLACE PROCEDURE delete_role(
    p_role_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM roles WHERE role_id = p_role_id;
END;
$$;

-- =============================================================================
-- PERMISSION MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to create a new permission
CREATE OR REPLACE PROCEDURE create_permission(
    p_permission_key VARCHAR(255),
    p_description TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO permissions (permission_key, description)
    VALUES (p_permission_key, p_description);
END;
$$;

-- Procedure to update a permission
CREATE OR REPLACE PROCEDURE update_permission(
    p_permission_id INT,
    p_permission_key VARCHAR(255),
    p_description TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE permissions
    SET permission_key = p_permission_key,
        description = p_description,
        updated_at = NOW()
    WHERE permission_id = p_permission_id;
END;
$$;

-- Procedure to delete a permission
CREATE OR REPLACE PROCEDURE delete_permission(
    p_permission_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM permissions WHERE permission_id = p_permission_id;
END;
$$;

-- =============================================================================
-- ROLE-PERMISSION ASSIGNMENT PROCEDURES
-- =============================================================================

-- Procedure to assign a permission to a role
CREATE OR REPLACE PROCEDURE assign_permission_to_role(
    p_role_id INT,
    p_permission_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO roles_permissions (role_id, permission_id)
    VALUES (p_role_id, p_permission_id)
    ON CONFLICT (role_id, permission_id) DO NOTHING;
END;
$$;

-- Procedure to remove a permission from a role
CREATE OR REPLACE PROCEDURE remove_permission_from_role(
    p_role_id INT,
    p_permission_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM roles_permissions
    WHERE role_id = p_role_id AND permission_id = p_permission_id;
END;
$$;

-- =============================================================================
-- USER MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to create a new user
CREATE OR REPLACE PROCEDURE create_user(
    p_username VARCHAR(255),
    p_email VARCHAR(255),
    p_password_hash TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO users (username, email, password_hash)
    VALUES (p_username, p_email, p_password_hash);
END;
$$;

-- Procedure to update a user
CREATE OR REPLACE PROCEDURE update_user(
    p_user_id INT,
    p_username VARCHAR(255) DEFAULT NULL,
    p_email VARCHAR(255) DEFAULT NULL,
    p_password_hash TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE users
    SET username = COALESCE(p_username, username),
        email = COALESCE(p_email, email),
        password_hash = COALESCE(p_password_hash, password_hash),
        updated_at = NOW()
    WHERE user_id = p_user_id;
END;
$$;

-- Procedure to delete a user
CREATE OR REPLACE PROCEDURE delete_user(
    p_user_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
END;
$$;

-- =============================================================================
-- USER-ROLE ASSIGNMENT PROCEDURES
-- =============================================================================

-- Procedure to assign a role to a user
CREATE OR REPLACE PROCEDURE assign_role_to_user(
    p_user_id INT,
    p_role_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    VALUES (p_user_id, p_role_id)
    ON CONFLICT (user_id, role_id) DO NOTHING;
END;
$$;

-- Procedure to remove a role from a user
CREATE OR REPLACE PROCEDURE remove_role_from_user(
    p_user_id INT,
    p_role_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM user_roles
    WHERE user_id = p_user_id AND role_id = p_role_id;
END;
$$;

-- =============================================================================
-- SETTINGS MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to create a new setting
CREATE OR REPLACE PROCEDURE create_setting(
    p_setting_key VARCHAR(255),
    p_setting_default_value TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO settings (setting_key, setting_default_value)
    VALUES (p_setting_key, p_setting_default_value);
END;
$$;

-- Procedure to update a setting
CREATE OR REPLACE PROCEDURE update_setting(
    p_setting_id INT,
    p_setting_key VARCHAR(255) DEFAULT NULL,
    p_setting_default_value TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE settings
    SET setting_key = COALESCE(p_setting_key, setting_key),
        setting_default_value = COALESCE(p_setting_default_value, setting_default_value),
        updated_at = NOW()
    WHERE setting_id = p_setting_id;
END;
$$;

-- Procedure to delete a setting
CREATE OR REPLACE PROCEDURE delete_setting(
    p_setting_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM settings WHERE setting_id = p_setting_id;
END;
$$;

-- =============================================================================
-- SETTING OPTIONS MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to add an option to a setting
CREATE OR REPLACE PROCEDURE add_setting_option(
    p_setting_id INT,
    p_option_value VARCHAR(255)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO setting_options (setting_id, option_value)
    VALUES (p_setting_id, p_option_value)
    ON CONFLICT (setting_id, option_value) DO NOTHING;
END;
$$;

-- Procedure to remove an option from a setting
CREATE OR REPLACE PROCEDURE remove_setting_option(
    p_option_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM setting_options WHERE option_id = p_option_id;
END;
$$;

-- =============================================================================
-- USER SETTINGS MANAGEMENT PROCEDURES
-- =============================================================================

-- Procedure to set a user's setting value
CREATE OR REPLACE PROCEDURE set_user_setting(
    p_user_id INT,
    p_setting_id INT,
    p_option_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO user_settings (user_id, setting_id, option_id)
    VALUES (p_user_id, p_setting_id, p_option_id)
    ON CONFLICT (user_id, setting_id) DO UPDATE
    SET option_id = p_option_id,
        updated_at = NOW();
END;
$$;

-- Procedure to remove a user setting
CREATE OR REPLACE PROCEDURE remove_user_setting(
    p_user_id INT,
    p_setting_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM user_settings
    WHERE user_id = p_user_id AND setting_id = p_setting_id;
END;
$$;

-- Script ends here
