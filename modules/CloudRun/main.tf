
resource "google_cloud_run_service" "inventario-ms" {
  name     = "inventario-ms"                         # Nombre del servicio de Cloud Run
  location = var.region                              # Región donde se desplegará el servicio

  template {
    spec {
      containers {
        image = "us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/inventario-ms:latest"  # URL de la imagen de contenedor en Artifact Registry
        
        ports {
          container_port = 8000                      # Puerto del contenedor expuesto
        }

        resources {
          limits = {
            cpu    = "1"                             # Límite de CPU (1 vCPU)
            memory = "512Mi"                         # Límite de memoria (512 MiB)
          }
        }

        env {
          name  = "DB_USER"                          # Variable de entorno para el usuario de la base de datos
          value = "inventarios_user"
        }
        env {
          name  = "DB_PASSWORD"                      # Variable de entorno para la contraseña de la base de datos
          value = "123"
        }
        env {
          name  = "DB_HOST"                          # Variable de entorno para la IP pública de la base de datos
          value = var.inventariodb_ip_address        # Reemplazar "IP_ADDRESS" por la IP pública de Cloud SQL
        }
        env {
          name  = "DB_NAME"                          # Variable de entorno para el nombre de la base de datos
          value = "inventariosdb"
        }
      }
    }
  }

  traffic {
    percent         = 100                            # Enviar el 100% del tráfico a la última revisión
    latest_revision = true                           # Dirige el tráfico a la última revisión desplegada
  }

  autogenerate_revision_name = true                  # Habilitar la generación automática de nombres para cada revisión

  
}

# Configuración de IAM para permitir invocaciones no autenticadas
resource "google_cloud_run_service_iam_member" "allow_unauthenticated" {
  location = google_cloud_run_service.inventario-ms.location  # Ubicación del servicio Cloud Run
  service  = google_cloud_run_service.inventario-ms.name      # Nombre del servicio Cloud Run al que aplica el IAM
  role     = "roles/run.invoker"                             # Rol que permite invocar el servicio
  member   = "allUsers"                                      # Permitir acceso no autenticado a todos los usuarios
}

# api gateway
resource "google_cloud_run_service" "api-gateway" {
  name     = "api-gateway"                         # Nombre del servicio de Cloud Run
  location = var.region                              # Región donde se desplegará el servicio

  template {
    spec {
      containers {
        image = "us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/api-gateway:latest"  # URL de la imagen de contenedor en Artifact Registry
        
        ports {
          container_port = 8500                      # Puerto del contenedor expuesto
        }

        resources {
          limits = {
            cpu    = "1"                             # Límite de CPU (1 vCPU)
            memory = "512Mi"                         # Límite de memoria (512 MiB)
          }
        }

        env {
          name  = "USER_MS_URL"                          # Variable de entorno para el usuario de la base de datos
          value = var.usuarios-ms-url
        }
        env {
          name  = "INVENT_MS_URL"                      # Variable de entorno para la contraseña de la base de datos
          value = google_cloud_run_service.inventario-ms.status[0].url
        }
      }
    }
  }

  traffic {
    percent         = 100                            # Enviar el 100% del tráfico a la última revisión
    latest_revision = true                           # Dirige el tráfico a la última revisión desplegada
  }

  autogenerate_revision_name = true                  # Habilitar la generación automática de nombres para cada revisión

  
}

# Configuración de IAM para permitir invocaciones no autenticadas
resource "google_cloud_run_service_iam_member" "allow_unauthenticated_gateway" {
  location = google_cloud_run_service.api-gateway.location  # Ubicación del servicio Cloud Run
  service  = google_cloud_run_service.api-gateway.name      # Nombre del servicio Cloud Run al que aplica el IAM
  role     = "roles/run.invoker"                             # Rol que permite invocar el servicio
  member   = "allUsers"                                      # Permitir acceso no autenticado a todos los usuarios
}
 