-- This script executes all other SQL scripts in the correct order.
-- It's recommended to run this file to set up the database from scratch.

\c postgres;
DROP DATABASE IF EXISTS auth_db;
CREATE DATABASE auth_db;
\c auth_db;

\i structure.sql
\i procedures.sql

-- End of script
