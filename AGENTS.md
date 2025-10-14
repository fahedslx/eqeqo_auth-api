# Repository Guidelines

## Project Structure & Module Organization
The API entrypoint is in `src/main.rs`, which boots `auth_server` defined in `src/lib.rs`.
HTTP handlers live under `src/handlers/` by domain (users, services, roles, permissions, relations).
Shared DB access is in `src/database.rs` using SQLx pools.
Database bootstrap SQL lives in `db/`, seed assets in `assets/`, generated SQLx metadata in `sqlx-data.json`, and integration tests under `tests/api_tests.rs`.

## Build, Test, and Development Commands
Run `cargo check` for a fast type-pass before opening a PR.
Use `cargo fmt` and `cargo clippy -- -D warnings` to enforce formatting and lints; fix all warnings locally.
Start the service with `cargo run` once `DATABASE_URL` is set.
All tests for good and bad scenarios must be under `/tests`, and all must pass.

When schema changes, regenerate SQLx metadata via:
```bash
cargo sqlx prepare -- --lib
```
after applying run `db/run_all.sql`.

## Coding Style & Naming Conventions
Rust code follows `rustfmt.toml`: two-space indentation, no hard tabs, and braces on the next line.
Follow Rust best practices for clarity and consistency.
Group HTTP route registries by resource as in `src/lib.rs`, and keep handler responses minimal, returning typed structs that derive `serde::Serialize`.

## Testing Guidelines
Run `cargo test` to execute all unit and integration suites.
Integration tests in `tests/api_tests.rs` require a fresh `auth_api` database seeded with `db/run_all.sql`.
Name new tests `<feature>_behaves_as_expected` to match existing patterns.
For migrations or query updates, ensure SQLx compile-time checks pass by re-running:
```bash
cargo sqlx prepare
```

## Coding Style & Naming Conventions
Rust code follows `rustfmt.toml`: two-space indentation, no hard tabs, braces on the next line.
Follow Rust best practices.
Group HTTP route registries by resource as in `src/lib.rs`, and keep handler responses small, returning typed structs that derive `serde::Serialize`.

## Testing Guidelines
`cargo test` runs unit and integration suites; integration tests in `tests/api_tests.rs` expect a fresh `auth_api` database seeded with `db/run_all.sql`.
Name new tests `<feature>_behaves_as_expected` to match existing patterns.
For migrations or query changes, ensure SQLx compile-time checks pass locally by re-running `cargo sqlx prepare`.

## Commit & Pull Request Guidelines
Write imperative, present-tense commit subjects under 72 characters (e.g., `Add schema fallback for user handlers`).
Use prefixes like `fix:` or `feat:` when clarifying intent.
PRs should summarize behavior changes, mention required DB scripts, link issues, and include curl examples or SQL snippets when the API surface shifts.

## Security & Configuration Tips
Never commit `.env` files or credentials; rely on `dotenvy` locally and document required variables in PRs.
Limit pool size via `MAX_CONNECTIONS` when debugging to avoid exhausting local Postgres connections.
Always verify that new endpoints reject unauthorized access before merging.
