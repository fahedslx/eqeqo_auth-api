\connect postgres
DROP DATABASE IF EXISTS auth_api;
CREATE DATABASE auth_api;
\connect auth_api
\ir 'structure.sql'
\ir 'procedures.sql'
