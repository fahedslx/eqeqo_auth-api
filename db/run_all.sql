-- This script executes all other SQL scripts in the correct order.
-- It's recommended to run this file to set up the database from scratch.

\set ON_ERROR_STOP on

\echo 'Connecting to postgres database...'
\c postgres;

\echo 'Recreating auth_db database...'
DROP DATABASE IF EXISTS auth_db;
CREATE DATABASE auth_db;

\echo 'Switching connection to auth_db...'
\c auth_db;

\echo 'Loading database structure...'
\ir structure.sql

\echo 'Loading stored procedures...'
\ir procedures.sql

-- Uncomment the next line if you also want to load the demo data.
-- \ir demo_data.sql

\echo 'Database setup completed successfully.'

-- End of script
