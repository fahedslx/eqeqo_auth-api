# Repository Guidelines

## Project Structure & Module Organization
`src/main.rs` boots the service and delegates routing setup to `src/lib.rs`. HTTP handlers live in `src/handlers/` grouped by domain (users, services, roles, permissions, relations), while shared database access sits in `src/database.rs` using SQLx pools. Keep bootstrap SQL under `db/`, seed fixtures in `assets/`, generated SQLx metadata in `sqlx-data.json`, and integration tests in `tests/api_tests.rs`.

## Build, Test, and Development Commands
Use `cargo check` for a fast type pass before opening a PR. Run `cargo fmt` to apply the repository’s `rustfmt.toml`, and enforce lint cleanliness with `cargo clippy -- -D warnings`. Start the API locally via `cargo run` once `DATABASE_URL` is exported. Execute the full suite with `cargo test`; regenerate SQLx metadata after schema changes using `cargo sqlx prepare -- --lib` and apply `db/run_all.sql` first.

## Coding Style & Naming Conventions
Rust code follows two-space indentation, no tabs, and braces on the next line. Group routes by resource inside `src/lib.rs` and return compact structs deriving `serde::Serialize` from handlers. Prefer descriptive snake_case for modules and functions, and keep response DTOs in their domain folder to reduce coupling.

## Testing Guidelines
Integration tests live in `tests/api_tests.rs` and expect a fresh `auth_api` database seeded with `db/run_all.sql`. Name new tests `<feature>_behaves_as_expected` to match existing patterns. Always run `cargo test` before pushing to ensure unit and integration suites pass with SQLx checks regenerated when queries change.

## Commit & Pull Request Guidelines
Commit subjects should be imperative, present tense, and under 72 characters; prefix with clarifiers like `feat:` or `fix:` when useful. PRs should summarize behavioral changes, call out required DB scripts, link relevant issues, and provide example curl or SQL snippets when the API surface shifts.

## Security & Configuration Tips
Never commit `.env` files or credentials—use `dotenvy` locally instead. Document required environment variables in PRs and limit connection pool size with `MAX_CONNECTIONS` when debugging to avoid exhausting Postgres. Confirm new endpoints reject unauthorized access before merge.
