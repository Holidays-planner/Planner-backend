CREATE OR REPLACE FUNCTION insert_role_action(role_name VARCHAR, action_key VARCHAR, scope VARCHAR)
RETURNS VOID AS $$
DECLARE
    v_role_id INT;
    v_action_id INT;
BEGIN
    SELECT r.id INTO v_role_id FROM roles r WHERE r.role_name = insert_role_action.role_name;
    IF v_role_id IS NULL THEN
        RAISE EXCEPTION 'Role % does not exist', role_name;
    END IF;

    SELECT a.id INTO v_action_id FROM actions a WHERE a.action_key = insert_role_action.action_key AND a.scope = insert_role_action.scope;
    IF v_action_id IS NULL THEN
        RAISE EXCEPTION 'Action % with scope % does not exist', action_key, scope;
    END IF;

    INSERT INTO role_actions (role_id, action_id)
    VALUES (v_role_id, v_action_id)
    ON CONFLICT (role_id, action_id) DO NOTHING;
END;
$$ LANGUAGE plpgsql;