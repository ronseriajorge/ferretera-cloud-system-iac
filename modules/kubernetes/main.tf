
resource "kubernetes_deployment_v1" "example_app" {
  metadata {
    name = var.app_name
    labels = {
      app = var.app_name
    }
  }

  spec {
    replicas = var.replicas
    selector {
      match_labels = {
        app = var.app_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }

      spec {
        container {
          image = var.container_image
          name  = var.app_name
          port {
            container_port = 4000
          }
          env {
            name  = "DB_USER"                          # Variable de entorno para el usuario de la base de datos
            value = "productos_user"
          }
          env {
            name  = "DB_PASSWORD"                      # Variable de entorno para la contraseña de la base de datos
            value = "123"
          }
          env {
            name  = "DB_HOST"                          # Variable de entorno para la IP pública de la base de datos
            value = var.productosdb_ip_address        # Reemplazar "IP_ADDRESS" por la IP pública de Cloud SQL
          }
          env {
            name  = "DB_NAME"                          # Variable de entorno para el nombre de la base de datos
            value = "productosdb"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example_service" {
  metadata {
    name = var.service_name
  }

  spec {
    selector = {
      app = var.app_name
    }

    port {
      port        = 4000
      target_port = 4000
    }

    type = "LoadBalancer"
  }
}
