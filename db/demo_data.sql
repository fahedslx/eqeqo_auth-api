INSERT INTO services (name)
VALUES
  ('Service A'),
  ('Service B'),
  ('Service C');

INSERT INTO auth.roles (name)
VALUES
  ('Admin'),
  ('User'),
  ('Editor'),
  ('Viewer');

INSERT INTO auth.permissions (name)
VALUES
  ('read'),
  ('write'),
  ('update'),
  ('delete'),
  ('share');

INSERT INTO auth.people (username, password_hash)
VALUES
  ('adm1', crypt('adm1', gen_salt('bf'))),
  ('usr1', crypt('usr1', gen_salt('bf'))),
  ('usr2', crypt('usr2', gen_salt('bf'))),
  ('usr3', crypt('usr3', gen_salt('bf'))),
  ('editor1', crypt('editor1', gen_salt('bf'))),
  ('viewer1', crypt('viewer1', gen_salt('bf')));

INSERT INTO auth.role_permissions (role_id, permission_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (2, 1),
  (3, 5),
  (4, 6);

INSERT INTO auth.service_roles (service_id, role_id)
VALUES
  (1, 1),
  (1, 2),
  (2, 2),
  (3, 3);

INSERT INTO auth.person_service_roles (person_id, service_id, role_id)
VALUES
  (1, 1, 1),
  (2, 1, 2),
  (3, 2, 2),
  (4, 3, 3);
