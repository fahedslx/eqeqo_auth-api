use auth_api::auth_server;
use httpageboy::test_utils::{run_test, setup_test_server, SERVER_URL};
use httpageboy::Server;

async fn create_test_server() -> Server {
    dotenvy::dotenv().ok();
    auth_server(SERVER_URL, 1).await
}

#[tokio::test]
async fn test_home() {
    setup_test_server(create_test_server).await;
    let req = b"GET / HTTP/1.1\r\n\r\n";
    run_test(req, b"Welcome to the Auth API");
}

// Users
#[tokio::test]
async fn test_list_users_success() {
    setup_test_server(create_test_server).await;
    let req = b"GET /users HTTP/1.1\r\n\r\n";
    run_test(req, b"[]"); // Should be an empty array initially
}

#[tokio::test]
async fn test_get_user_not_found() {
    setup_test_server(create_test_server).await;
    let req = b"GET /users/999 HTTP/1.1\r\n\r\n";
    run_test(req, b"User not found");
}

#[tokio::test]
async fn test_create_user_success() {
    setup_test_server(create_test_server).await;
    let req = b"POST /users HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"username\":\"testuser\",\"password_hash\":\"hash\",\"name\":\"Test User\",\"person_type\":\"N\",\"document_type\":\"DNI\",\"document_number\":\"12345678\"}";
    run_test(req, b"\"username\":\"testuser\"");
}

#[tokio::test]
async fn test_update_user_invalid_id() {
    setup_test_server(create_test_server).await;
    let req = b"PUT /users/abc HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"username\":\"x\"}";
    run_test(req, b"Invalid user ID");
}

#[tokio::test]
async fn test_delete_user_success() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /users HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"username\":\"todelete\",\"password_hash\":\"p\",\"name\":\"To Delete\",\"person_type\":\"N\",\"document_type\":\"DNI\",\"document_number\":\"87654321\"}";
    run_test(create_req, b"\"id\":1");

    let delete_req = b"DELETE /users/1 HTTP/1.1\r\n\r\n";
    run_test(delete_req, b""); // Expecting 204 No Content
}

// Services
#[tokio::test]
async fn test_list_services() {
    setup_test_server(create_test_server).await;
    let req = b"GET /services HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

#[tokio::test]
async fn test_create_service_missing_body() {
    setup_test_server(create_test_server).await;
    let req = b"POST /services HTTP/1.1\r\n\r\n";
    run_test(req, b"Invalid request body");
}

#[tokio::test]
async fn test_update_service() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /services HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"service1\"}";
    run_test(create_req, b"\"id\":1");

    let update_req = b"PUT /services/1 HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"svc\"}";
    run_test(update_req, b"success");
}

#[tokio::test]
async fn test_delete_service_not_found() {
    setup_test_server(create_test_server).await;
    let req = b"DELETE /services/999 HTTP/1.1\r\n\r\n";
    run_test(req, b"Failed to delete service");
}

// Roles
#[tokio::test]
async fn test_list_roles() {
    setup_test_server(create_test_server).await;
    let req = b"GET /roles HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

#[tokio::test]
async fn test_get_role_success() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"role1\"}";
    run_test(create_req, b"\"id\":1");

    let get_req = b"GET /roles/1 HTTP/1.1\r\n\r\n";
    run_test(get_req, b"\"name\":\"role1\"");
}

#[tokio::test]
async fn test_create_role_conflict() {
    setup_test_server(create_test_server).await;
    let req = b"POST /roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"existing\"}";
    run_test(req, b"\"name\":\"existing\"");
    run_test(req, b"Failed to create role");
}

#[tokio::test]
async fn test_update_role() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"role2\"}";
    run_test(create_req, b"\"id\":1");
    let req = b"PUT /roles/1 HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"new\"}";
    run_test(req, b"success");
}

#[tokio::test]
async fn test_delete_role() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"role3\"}";
    run_test(create_req, b"\"id\":1");
    let req = b"DELETE /roles/1 HTTP/1.1\r\n\r\n";
    run_test(req, b"");
}

// Permissions
#[tokio::test]
async fn test_list_permissions() {
    setup_test_server(create_test_server).await;
    let req = b"GET /permissions HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

#[tokio::test]
async fn test_create_permission() {
    setup_test_server(create_test_server).await;
    let req = b"POST /permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"p\"}";
    run_test(req, b"\"name\":\"p\"");
}

#[tokio::test]
async fn test_update_permission() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"p1\"}";
    run_test(create_req, b"\"id\":1");
    let req = b"PUT /permissions/1 HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"p2\"}";
    run_test(req, b"success");
}

#[tokio::test]
async fn test_delete_permission() {
    setup_test_server(create_test_server).await;
    let create_req = b"POST /permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"p3\"}";
    run_test(create_req, b"\"id\":1");
    let req = b"DELETE /permissions/1 HTTP/1.1\r\n\r\n";
    run_test(req, b"");
}

// Role-Permissions
#[tokio::test]
async fn test_assign_permission_to_role() {
    setup_test_server(create_test_server).await;
    let _ = b"POST /roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"role_for_perm\"}";
    let _ = b"POST /permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"name\":\"perm_for_role\"}";

    let req = b"POST /role-permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"role_id\":1,\"permission_id\":1}";
    run_test(req, b"success");
}

#[tokio::test]
async fn test_remove_permission_from_role() {
    setup_test_server(create_test_server).await;
    let req = b"DELETE /role-permissions HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"role_id\":1,\"permission_id\":1}";
    run_test(req, b"");
}

#[tokio::test]
async fn test_list_role_permissions() {
    setup_test_server(create_test_server).await;
    let req = b"GET /roles/1/permissions HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

// Service-Roles
#[tokio::test]
async fn test_assign_role_to_service() {
    setup_test_server(create_test_server).await;
    let req = b"POST /service-roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"service_id\":1,\"role_id\":1}";
    run_test(req, b"success");
}

#[tokio::test]
async fn test_remove_role_from_service() {
    setup_test_server(create_test_server).await;
    let req = b"DELETE /service-roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"service_id\":1,\"role_id\":1}";
    run_test(req, b"");
}

#[tokio::test]
async fn test_list_service_roles() {
    setup_test_server(create_test_server).await;
    let req = b"GET /services/1/roles HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

// Person-Service-Roles
#[tokio::test]
async fn test_assign_role_to_person_in_service() {
    setup_test_server(create_test_server).await;
    let req = b"POST /person-service-roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"person_id\":1,\"service_id\":1,\"role_id\":1}";
    run_test(req, b"success");
}

#[tokio::test]
async fn test_remove_role_from_person_in_service() {
    setup_test_server(create_test_server).await;
    let req = b"DELETE /person-service-roles HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"person_id\":1,\"service_id\":1,\"role_id\":1}";
    run_test(req, b"");
}

#[tokio::test]
async fn test_list_person_roles_in_service() {
    setup_test_server(create_test_server).await;
    let req = b"GET /people/1/services/1/roles HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

#[tokio::test]
async fn test_list_persons_with_role_in_service() {
    setup_test_server(create_test_server).await;
    let req = b"GET /services/1/roles/1/people HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}

// Checks
#[tokio::test]
async fn test_check_person_permission_in_service() {
    setup_test_server(create_test_server).await;
    let req = b"POST /check-permission HTTP/1.1\r\nContent-Type: application/json\r\n\r\n{\"person_id\":1,\"service_id\":1,\"permission_name\":\"read\"}";
    run_test(req, b"\"has_permission\":false");
}

#[tokio::test]
async fn test_list_services_of_person() {
    setup_test_server(create_test_server).await;
    let req = b"GET /people/1/services HTTP/1.1\r\n\r\n";
    run_test(req, b"[]");
}