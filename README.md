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

* Create a PostgreSQL database.
* Run the SQL scripts located in the `/db` directory in order:

  1. `db/structure.sql` – creates the tables
  2. `db/procedures.sql` – defines the functions and stored procedures

Example (from terminal):

```bash
psql -U <user> -d <database_name> -f db/structure.sql
psql -U <user> -d <database_name> -f db/procedures.sql
```

### 3. Configure the environment

Create a `.env` file in the root directory and add your PostgreSQL connection string:

```env
DATABASE_URL=postgres://USER:PASSWORD@HOST/DB_NAME
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

