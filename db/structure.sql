-- Main Schema for the Authentication and Authorization API

-- Schemas
CREATE SCHEMA IF NOT EXISTS people;
CREATE SCHEMA IF NOT EXISTS services;

-- Custom Types
CREATE TYPE people.document_type AS ENUM ('DNI', 'CE', 'RUC');
CREATE TYPE people.person_type AS ENUM ('N', 'J');

-- Tables
CREATE TABLE people.person (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE, -- Added for authentication
  password_hash TEXT NOT NULL, -- Added for authentication
  name TEXT NOT NULL,
  person_type people.person_type NOT NULL DEFAULT 'N',
  document_type people.document_type NOT NULL DEFAULT 'DNI',
  document_number TEXT NOT NULL,
  created_at BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
  removed_at BIGINT,
  UNIQUE (document_type, document_number)
);

CREATE TABLE people.role (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE people.permission (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE services.services (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at BIGINT NOT NULL DEFAULT EXTRACT(EPOCH FROM NOW())::BIGINT,
  status BOOLEAN NOT NULL DEFAULT TRUE
);

-- Linking Tables

-- Role-Permissions (based on user schema, corrected reference)
CREATE TABLE people.role_permission (
  id SERIAL PRIMARY KEY,
  role_id INTEGER REFERENCES people.role(id) ON DELETE CASCADE NOT NULL,
  permission_id INTEGER REFERENCES people.permission(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (role_id, permission_id)
);

-- Service-Roles (new, as required by API)
CREATE TABLE services.service_roles (
  id SERIAL PRIMARY KEY,
  service_id INTEGER REFERENCES services.services(id) ON DELETE CASCADE NOT NULL,
  role_id INTEGER REFERENCES people.role(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (service_id, role_id)
);

-- Person-Service-Roles (new, as required by API, replaces user's person_role)
CREATE TABLE people.person_service_role (
  id SERIAL PRIMARY KEY,
  person_id INTEGER REFERENCES people.person(id) ON DELETE CASCADE NOT NULL,
  service_id INTEGER REFERENCES services.services(id) ON DELETE CASCADE NOT NULL,
  role_id INTEGER REFERENCES people.role(id) ON DELETE CASCADE NOT NULL,
  UNIQUE (person_id, service_id, role_id)
);