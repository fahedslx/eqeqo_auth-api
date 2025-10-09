-- Procedures for People (Users, Roles, Permissions)

-- Function to create a person and return their basic info
CREATE OR REPLACE FUNCTION people.create_person(
    p_username TEXT,
    p_password_hash TEXT,
    p_name TEXT,
    p_person_type people.person_type,
    p_document_type people.document_type,
    p_document_number TEXT
)
RETURNS TABLE(id INT, username TEXT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    INSERT INTO people.person (username, password_hash, name, person_type, document_type, document_number)
    VALUES (p_username, p_password_hash, p_name, p_person_type, p_document_type, p_document_number)
    RETURNING people.person.id, people.person.username, people.person.name;
END;
$$ LANGUAGE plpgsql;

-- Function to list all people
CREATE OR REPLACE FUNCTION people.list_people()
RETURNS TABLE(id INT, username TEXT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.username, p.name FROM people.person p WHERE p.removed_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to get a single person by ID
CREATE OR REPLACE FUNCTION people.get_person(p_id INT)
RETURNS TABLE(id INT, username TEXT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.username, p.name FROM people.person p WHERE p.id = p_id AND p.removed_at IS NULL;
END;
$$ LANGUAGE plpgsql;

-- Procedure to update a person
CREATE OR REPLACE PROCEDURE people.update_person(
    p_id INT,
    p_username TEXT,
    p_password_hash TEXT,
    p_name TEXT
) AS $$
BEGIN
    UPDATE people.person
    SET
        username = COALESCE(p_username, username),
        password_hash = COALESCE(p_password_hash, password_hash),
        name = COALESCE(p_name, name)
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Procedure to delete a person (soft delete)
CREATE OR REPLACE PROCEDURE people.delete_person(p_id INT) AS $$
BEGIN
    UPDATE people.person
    SET removed_at = NOW()
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Functions for Roles
CREATE OR REPLACE FUNCTION people.create_role(p_name TEXT)
RETURNS SETOF people.role AS $$
BEGIN
    RETURN QUERY
    INSERT INTO people.role (name) VALUES (p_name) RETURNING *;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_roles()
RETURNS SETOF people.role AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM people.role;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.get_role(p_id INT)
RETURNS SETOF people.role AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM people.role WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.update_role(p_id INT, p_name TEXT) AS $$
BEGIN
    UPDATE people.role SET name = p_name WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.delete_role(p_id INT) AS $$
BEGIN
    DELETE FROM people.role WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;


-- Functions for Permissions
CREATE OR REPLACE FUNCTION people.create_permission(p_name TEXT)
RETURNS SETOF people.permission AS $$
BEGIN
    RETURN QUERY
    INSERT INTO people.permission (name) VALUES (p_name) RETURNING *;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_permissions()
RETURNS SETOF people.permission AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM people.permission;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.update_permission(p_id INT, p_name TEXT) AS $$
BEGIN
    UPDATE people.permission SET name = p_name WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.delete_permission(p_id INT) AS $$
BEGIN
    DELETE FROM people.permission WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Procedures for Services
CREATE OR REPLACE FUNCTION services.create_service(p_name TEXT, p_description TEXT)
RETURNS SETOF services.services AS $$
BEGIN
    RETURN QUERY
    INSERT INTO services.services (name, description) VALUES (p_name, p_description) RETURNING *;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION services.list_services()
RETURNS SETOF services.services AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM services.services WHERE status = TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE services.update_service(p_id INT, p_name TEXT, p_description TEXT) AS $$
BEGIN
    UPDATE services.services
    SET
        name = COALESCE(p_name, name),
        description = COALESCE(p_description, description)
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE services.delete_service(p_id INT) AS $$
BEGIN
    UPDATE services.services SET status = FALSE WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;


-- Relationship Management Procedures
CREATE OR REPLACE PROCEDURE people.assign_permission_to_role(p_role_id INT, p_permission_id INT) AS $$
BEGIN
    INSERT INTO people.role_permission (role_id, permission_id) VALUES (p_role_id, p_permission_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.remove_permission_from_role(p_role_id INT, p_permission_id INT) AS $$
BEGIN
    DELETE FROM people.role_permission WHERE role_id = p_role_id AND permission_id = p_permission_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_role_permissions(p_role_id INT)
RETURNS SETOF people.permission AS $$
BEGIN
    RETURN QUERY
    SELECT p.* FROM people.permission p
    JOIN people.role_permission rp ON p.id = rp.permission_id
    WHERE rp.role_id = p_role_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE services.assign_role_to_service(p_service_id INT, p_role_id INT) AS $$
BEGIN
    INSERT INTO services.service_roles (service_id, role_id) VALUES (p_service_id, p_role_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE services.remove_role_from_service(p_service_id INT, p_role_id INT) AS $$
BEGIN
    DELETE FROM services.service_roles WHERE service_id = p_service_id AND role_id = p_role_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION services.list_service_roles(p_service_id INT)
RETURNS SETOF people.role AS $$
BEGIN
    RETURN QUERY
    SELECT r.* FROM people.role r
    JOIN services.service_roles sr ON r.id = sr.role_id
    WHERE sr.service_id = p_service_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.assign_role_to_person_in_service(p_person_id INT, p_service_id INT, p_role_id INT) AS $$
BEGIN
    INSERT INTO people.person_service_role (person_id, service_id, role_id) VALUES (p_person_id, p_service_id, p_role_id);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE people.remove_role_from_person_in_service(p_person_id INT, p_service_id INT, p_role_id INT) AS $$
BEGIN
    DELETE FROM people.person_service_role
    WHERE person_id = p_person_id AND service_id = p_service_id AND role_id = p_role_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_person_roles_in_service(p_person_id INT, p_service_id INT)
RETURNS SETOF people.role AS $$
BEGIN
    RETURN QUERY
    SELECT r.* FROM people.role r
    JOIN people.person_service_role psr ON r.id = psr.role_id
    WHERE psr.person_id = p_person_id AND psr.service_id = p_service_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_persons_with_role_in_service(p_service_id INT, p_role_id INT)
RETURNS TABLE(id INT, username TEXT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.username, p.name FROM people.person p
    JOIN people.person_service_role psr ON p.id = psr.person_id
    WHERE psr.service_id = p_service_id AND psr.role_id = p_role_id AND p.removed_at IS NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.check_person_permission_in_service(p_person_id INT, p_service_id INT, p_permission_name TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    has_permission BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM people.person_service_role psr
        JOIN people.role_permission rp ON psr.role_id = rp.role_id
        JOIN people.permission p ON rp.permission_id = p.id
        WHERE psr.person_id = p_person_id
          AND psr.service_id = p_service_id
          AND p.name = p_permission_name
    ) INTO has_permission;
    RETURN has_permission;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION people.list_services_of_person(p_person_id INT)
RETURNS TABLE(id INT, name TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT s.id, s.name FROM services.services s
    JOIN people.person_service_role psr ON s.id = psr.service_id
    WHERE psr.person_id = p_person_id AND s.status = TRUE;
END;
$$ LANGUAGE plpgsql;
