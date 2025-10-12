use sqlx::{Pool, Postgres, postgres::PgPoolOptions};
use std::env;

#[derive(Clone)]
pub struct DB {
  pool: Pool<Postgres>,
}

impl DB {
  /// Create a pooled Postgres connection
  pub async fn new() -> Result<Self, sqlx::Error> {
    // Fallback: try to load .env if it has not been loaded yet
    let _ = dotenvy::dotenv();

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");

    let max_conns: u32 = env::var("MAX_CONNECTIONS")
      .ok()
      .and_then(|v| v.parse().ok())
      .unwrap_or(5);

    let pool = PgPoolOptions::new()
      .max_connections(max_conns)
      .connect(&database_url)
      .await?;

    Ok(Self { pool })
  }

  pub fn pool(&self) -> &Pool<Postgres> {
    &self.pool
  }
}
