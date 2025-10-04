use sqlx::{postgres::PgPoolOptions, Pool, Postgres};
use std::env;

#[derive(Clone)]
pub struct DB {
    pool: Pool<Postgres>,
}

impl DB {
    pub async fn new() -> Result<Self, sqlx::Error> {
        let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
        let pool = PgPoolOptions::new()
            .max_connections(5)
            .connect(&database_url)
            .await?;
        Ok(Self { pool })
    }

    pub fn pool(&self) -> &Pool<Postgres> {
        &self.pool
    }
}