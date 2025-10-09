# auth-api

Minimal standalone authentication and authorization API for centralized user management.

## Usage

**Prerequisites:**

* Rust
* PostgreSQL

### 1. Clone the repository

```bash
git clone <repository_url>
cd auth-api
```

---

### 2. Set up the database

*   Run the `run_all.sql` script located in the `/db` directory. This script will automatically create the database (named `auth_db`) and set up all the necessary tables and procedures.

Example (from your terminal, you might need to connect as a superuser like `postgres` initially):

```bash
psql -U <user> -f db/run_all.sql
```

### 3. Configure the environment

Create a `.env` file in the root directory and add your PostgreSQL connection string. Make sure the database name is `auth_db` as created by the script.

```env
DATABASE_URL=postgres://USER:PASSWORD@HOST/auth_db
```

### 4. Run the API server

```bash
cargo run
```

If successful, the server will start on:

```
http://127.0.0.1:7878
```

## License

Copyright (c) 2025
[fahedsl](https://gitlab.com/fahedsl)

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

## Endpoints

| Method | Path                                      | Description                                |
|--------|-------------------------------------------|--------------------------------------------|
| GET    | /                                         | Home                                       |
| GET    | /users                                    | List all users                             |
| POST   | /users                                    | Create a new user                          |
| GET    | /users/{id}                               | Get a user by ID                           |
| PUT    | /users/{id}                               | Update a user by ID                        |
| DELETE | /users/{id}                               | Delete a user by ID                        |
| GET    | /services                                 | List all services                          |
| POST   | /services                                 | Create a new service                       |
| PUT    | /services/{id}                            | Update a service by ID                     |
| DELETE | /services/{id}                            | Delete a service by ID                     |
| GET    | /roles                                    | List all roles                             |
| POST   | /roles                                    | Create a new role                          |
| GET    | /roles/{id}                               | Get a role by ID                           |
| PUT    | /roles/{id}                               | Update a role by ID                        |
| DELETE | /roles/{id}                               | Delete a role by ID                        |
| GET    | /permissions                              | List all permissions                       |
| POST   | /permissions                              | Create a new permission                    |
| PUT    | /permissions/{id}                         | Update a permission by ID                  |
| DELETE | /permissions/{id}                         | Delete a permission by ID                  |
| POST   | /role-permissions                         | Assign a permission to a role              |
| DELETE | /role-permissions                         | Remove a permission from a role            |
| GET    | /roles/{id}/permissions                   | List all permissions for a role            |
| POST   | /service-roles                            | Assign a role to a service                 |
| DELETE | /service-roles                            | Remove a role from a service               |
| GET    | /services/{id}/roles                      | List all roles for a service               |
| POST   | /person-service-roles                     | Assign a role to a person in a service     |
| DELETE | /person-service-roles                     | Remove a role from a person in a service   |
| GET    | /people/{person_id}/services/{service_id}/roles | List all roles for a person in a service   |
| GET    | /services/{service_id}/roles/{role_id}/people | List all people with a role in a service |
| GET    | /check-permission                         | Check if a person has a permission         |
| GET    | /people/{person_id}/services              | List all services for a person             |
