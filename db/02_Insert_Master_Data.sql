CREATE OR REPLACE PROCEDURE insert_initial_data()
LANGUAGE plpgsql AS $$
BEGIN
    -- Insert initial roles
    INSERT INTO roles (role_name, description) VALUES
        ('admin', 'Administrator with full access'),
        ('editor', 'Editor with content management access'),
        ('viewer', 'Viewer with read-only access')
    ON CONFLICT (role_name) DO NOTHING;
    -- Insert initial settings
    INSERT INTO settings (setting_key, setting_name, setting_default_value) VALUES
        ('theme', 'Theme', 'light'),
        ('language', 'Lenguaje', 'en'),
        ('friend_requests', 'Friend Requests', 'enabled')
    ON CONFLICT (setting_key) DO NOTHING;

    -- Insert initial setting options
    INSERT INTO setting_options (setting_id, option_value) VALUES
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'theme'), 'light'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'theme'), 'dark'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'language'), 'en'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'language'), 'es'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'friend_requests'), 'enabled'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'friend_requests'), 'disabled'),
        ((SELECT setting_id FROM "settings" WHERE setting_key = 'friend_requests'), 'requires_approval')
    ON CONFLICT (setting_id, option_value) DO NOTHING;
END;
$$;

CALL insert_initial_data();

CREATE OR REPLACE FUNCTION populate_user_defaults()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    SELECT
        NEW.user_id,
        role_id
    FROM
        roles
    WHERE role_name = 'viewer';
    INSERT INTO user_settings (user_id, setting_id, setting_value)
    SELECT
        NEW.user_id,
        s.setting_id,
        s.setting_default_value
    FROM
        "settings" s;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION populate_user_defaults();