CREATE OR REPLACE PROCEDURE insert_initial_data()
LANGUAGE plpgsql AS $$
BEGIN
    -- Insert initial roles
    INSERT INTO roles (role_name, description) VALUES
        ('admin', 'Administrator with full access'),
        ('user', 'Approved user with standard access'),
        ('viewer', 'Viewer with read-only access'),
        ('owner', 'Owner of the vacation plan'),
        ('participant', 'Participant on the vacation plan'),
        ('collaborator', 'Collaborator on the vacation plan')
    ON CONFLICT (role_name) DO NOTHING;
    -- Insert initial settings
    INSERT INTO settings (setting_key, setting_name, setting_default_value) VALUES
        ('theme', 'Theme', 'light'),
        ('language', 'Lenguaje', 'en'),
        ('friend_requests', 'Friend Requests', 'enabled')
    ON CONFLICT (setting_key) DO NOTHING;

    -- Insert initial setting options
    INSERT INTO setting_options (setting_id, option_value) VALUES
        ((SELECT id FROM "settings" WHERE setting_key = 'theme'), 'light'),
        ((SELECT id FROM "settings" WHERE setting_key = 'theme'), 'dark'),
        ((SELECT id FROM "settings" WHERE setting_key = 'language'), 'en'),
        ((SELECT id FROM "settings" WHERE setting_key = 'language'), 'es'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'enabled'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'disabled'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'requires_approval')
    ON CONFLICT (setting_id, option_value) DO NOTHING;

    -- Insert initial actions
    INSERT INTO actions (action_key, scope, action_name, description) VALUES
        ('create_vacation', 'vacation', 'Create Vacation', 'Create a new vacation plan'),
        ('view_vacation', 'vacation', 'View Vacation', 'View vacation details'),
        ('edit_vacation', 'vacation', 'Edit Vacation', 'Edit vacation details'),
        ('delete_vacation', 'vacation', 'Delete Vacation', 'Delete a vacation plan'),
        ('add_participant', 'vacation', 'Add Participant', 'Add a participant to the vacation plan'),
        ('remove_participant', 'vacation', 'Remove Participant', 'Remove a participant from the vacation plan'),
        ('manage_settings', 'global', 'Manage Settings', 'Manage user settings'),
        ('manage_users', 'global', 'Manage Users', 'Manage user accounts'),
        ('manage_roles', 'global', 'Manage Roles', 'Manage user roles and permissions'),
        ('view_settings', 'global', 'View Settings', 'View global settings'),
        ('view_settings', 'user', 'View Settings', 'View user settings'),
        ('edit_settings', 'user', 'Edit Settings', 'Edit user settings'),
        ('manage_friend_request', 'user', 'Manage Friend Request', 'Manage friend requests'),
        ('manage_friends', 'user', 'Manage Friend', 'Remove a user from friends list')
    ON CONFLICT (action_key, scope) DO NOTHING;

END;
$$;

CALL insert_initial_data();

CREATE OR REPLACE FUNCTION populate_user_defaults()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    SELECT
        NEW.id,
        r.id
    FROM
        roles r
    WHERE role_name = 'viewer';
    INSERT INTO user_settings (user_id, setting_id, setting_value)
    SELECT
        NEW.id,
        s.id,
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