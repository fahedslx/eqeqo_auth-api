-- Main Schema for the Authentication and Authorization API

-- Schemas
CREATE SCHEMA IF NOT EXISTS auth;

-- Custom Types
CREATE TYPE auth.document_type AS ENUM ('DNI', 'CE', 'RUC');
CREATE TYPE auth.person_type AS ENUM ('N', 'J');

-- Tables
CREATE TABLE auth.person (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE, -- Added for authentication
  password_hash TEXT NOT NULL, -- Added for authentication
  name TEXT NOT NULL,
  person_type auth.person_type NOT NULL DEFAULT 'N',
  document_type auth.document_type NOT NULL DEFAULT 'DNI',
  document_number TEXT NOT NULL,
  created_at BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
  removed_at BIGINT,
  UNIQUE (document_type, document_number)
);

CREATE TABLE auth.role (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE auth.permission (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE auth.services (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
  status BOOLEAN NOT NULL DEFAULT TRUE
);

-- Linking Tables

-- Role-Permissions (based on user schema, corrected reference)
CREATE TABLE auth.role_permission (
  id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES auth.role(id) ON DELETE CASCADE NOT NULL,
  permission_id INTEGER REFERENCES auth.permission(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (role_id, permission_id)
);

-- Service-Roles (new, as required by API)
CREATE TABLE auth.service_roles (
  id SERIAL PRIMARY KEY,
  service_id INTEGER REFERENCES auth.services(id) ON DELETE CASCADE NOT NULL,
  role_id INTEGER REFERENCES auth.role(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (service_id, role_id)
);

-- Person-Service-Roles (new, as required by API, replaces user's person_role)
CREATE TABLE auth.person_service_role (
  id SERIAL PRIMARY KEY,
  person_id INTEGER REFERENCES auth.person(id) ON DELETE CASCADE NOT NULL,
  service_id INTEGER REFERENCES auth.services(id) ON DELETE CASCADE NOT NULL,
  role_id INTEGER REFERENCES auth.role(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (person_id, service_id, role_id)
);
