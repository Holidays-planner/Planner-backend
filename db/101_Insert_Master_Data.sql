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
        ('language', 'Lenguaje', 'en'),
        ('friend_requests', 'Friend Requests', 'enabled')
    ON CONFLICT (setting_key) DO NOTHING;

    -- Insert initial setting options
    INSERT INTO setting_options (setting_id, option_value) VALUES
        ((SELECT id FROM "settings" WHERE setting_key = 'language'), 'en'),
        ((SELECT id FROM "settings" WHERE setting_key = 'language'), 'es'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'enabled'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'disabled'),
        ((SELECT id FROM "settings" WHERE setting_key = 'friend_requests'), 'requires_approval')
    ON CONFLICT (setting_id, option_value) DO NOTHING;

    -- Insert initial actions
    INSERT INTO actions (action_key, scope, action_name, description) VALUES
        ('view_users', 'global', 'View Users', 'View user accounts'),
        ('manage_users', 'global', 'Manage Users', 'Create, update, and delete user accounts'),
        ('manage_roles', 'global', 'Manage Roles', 'Manage user roles and permissions'),
        ('manage_settings', 'global', 'Manage Settings', 'Manage user settings'),
        ('manage_errors', 'global', 'Manage errors', 'Manage error messages globally'),
        ('view_actions', 'global', 'View Actions', 'View available actions'),
        ('create_action', 'global', 'Create Action', 'Create new actions'),
        ('update_action', 'global', 'Update Action', 'Update existing actions'),
        ('delete_action', 'global', 'Delete Action', 'Delete actions');
END;
$$;

CREATE OR REPLACE PROCEDURE run_initial_data_insertion()
LANGUAGE plpgsql AS $$
BEGIN
    -- Assign all actions to admin role
    PERFORM insert_role_action('admin', 'view_users', 'global');
    PERFORM insert_role_action('admin', 'manage_users', 'global');
    PERFORM insert_role_action('admin', 'manage_roles', 'global');
    PERFORM insert_role_action('admin', 'manage_settings', 'global');
    PERFORM insert_role_action('admin', 'manage_errors', 'global');
    PERFORM insert_role_action('admin', 'view_actions', 'global');
    PERFORM insert_role_action('admin', 'create_action', 'global');
    PERFORM insert_role_action('admin', 'update_action', 'global');
    PERFORM insert_role_action('admin', 'delete_action', 'global');
END;
$$;

CALL insert_initial_data();
CALL run_initial_data_insertion();