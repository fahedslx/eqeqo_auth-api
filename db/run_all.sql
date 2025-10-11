\echo 'Connecting to postgres database...'
\c postgres;

\echo 'Recreating auth_api database...'
DROP DATABASE IF EXISTS auth_api;
CREATE DATABASE auth_api;

\echo 'Switching connection to auth_api...'
\c auth_api;

\echo 'Loading database structure...'
\ir structure.sql

\echo 'Loading stored procedures...'
\ir procedures.sql

\echo 'Loading demo data...'
\ir demo_data.sql

\echo 'Database setup completed successfully.'
