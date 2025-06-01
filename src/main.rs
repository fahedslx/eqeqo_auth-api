use httpageboy::{Request, Response, Rh, Rt, Server, StatusCode};
use std::collections::HashMap;

fn list_users(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Listar usuarios".as_bytes().to_vec(),
    }
}

fn get_user(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Ver perfil de usuario".as_bytes().to_vec(),
    }
}

fn create_user(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Crear usuario".as_bytes().to_vec(),
    }
}

fn update_user(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Editar usuario".as_bytes().to_vec(),
    }
}

fn delete_user(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: Vec::new(),
    }
}

fn list_roles(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Listar roles".as_bytes().to_vec(),
    }
}

fn create_role(_req: &Request) -> Response {
    Response {
        status: StatusCode::Ok.to_string(),
        content_type: String::new(),
        content: "Demo: Crear rol".as_bytes().to_vec(),
    }
}

fn main() {
    let serving_url: &str = "127.0.0.1:7878";
    let threads_number: u8 = 10;

    // 1. Declaro un HashMap con clave (Rt, String) y valor Rh
    let mut routes: HashMap<(Rt, String), Rh> = HashMap::new();

    // 2. Inserto cada ruta en forma manual (clave = tupla (método, ruta))
    routes.insert(
        (Rt::GET, "/users".to_string()),
        Rh {
            handler: list_users,
        },
    );
    routes.insert(
        (Rt::GET, "/users/{id}".to_string()),
        Rh { handler: get_user },
    );
    routes.insert(
        (Rt::POST, "/users".to_string()),
        Rh {
            handler: create_user,
        },
    );
    routes.insert(
        (Rt::PUT, "/users/{id}".to_string()),
        Rh {
            handler: update_user,
        },
    );
    routes.insert(
        (Rt::DELETE, "/users/{id}".to_string()),
        Rh {
            handler: delete_user,
        },
    );
    routes.insert(
        (Rt::GET, "/roles".to_string()),
        Rh {
            handler: list_roles,
        },
    );
    routes.insert(
        (Rt::POST, "/roles".to_string()),
        Rh {
            handler: create_role,
        },
    );

    // 3. Paso ese HashMap al servidor
    let server = Server::new(serving_url, threads_number, Some(routes)).unwrap();
    server.run();
}
