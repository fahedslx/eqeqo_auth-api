use auth_api::auth_server;

#[tokio::main]
async fn main() {
    let server = auth_server("127.0.0.1:7878", 10).await;
    server.run().await;
}