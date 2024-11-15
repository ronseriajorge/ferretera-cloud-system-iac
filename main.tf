provider "google" {
  project =  var.project_id
  region  = var.region
}

data "google_client_config" "default" {}

module "APIs" {
  source     = "./modules/Apis"
  project_id =  var.project_id
}
module "Database" {
    source = "./modules/CloudSQL"
    db_inventarios = var.db_inventarios
    db_proveedores = var.db_proveedores
    db_empresas = var.db_empresas
    region = var.region
    depends_on    = [module.APIs]  # Asegura que el módulo de APIs se ejecute primero
}

module "Registry" {
  source = "./modules/Registry"
  depends_on = [ module.APIs ]
}

module "docker_commands" {
    source = "./modules/DockerCommands"
    depends_on    = [module.Registry]
}

module "Firestore" {
    source = "./modules/Firestore"  
    region = var.region
    db_usuarios = var.db_usuarios
    depends_on    = [module.APIs]  # Asegura que el módulo de APIs se ejecute primero
}

module "CloudFunction" {
    source = "./modules/CloudFunction"  
    region = var.region
    project_id = var.project_id
    depends_on    = [module.APIs]  # Asegura que el módulo de APIs  y firestpre se ejecute primero
}

module "CloudRun" {
  source = "./modules/CloudRun"  
  region = var.region
  inventariodb_ip_address =  module.Database.inventariodb_ip_address
  usuarios-ms-url = module.CloudFunction.url-usuarios-ms
  # Espera a que la imagen esté disponible antes de crear el servicio
  depends_on = [module.APIs, module.Database, module.docker_commands]
}

module "gke" {
  source           = "./modules/gke"
  cluster_name     = "cluster-productos"
  region           = var.region
  initial_node_count = 1
  machine_type     = "e2-medium"
}

provider "kubernetes" {
  host                   = module.gke.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate) 
}

module "kubernetes" {
  source = "./modules/kubernetes"

  providers = {
    kubernetes = kubernetes
  }

  kubernetes_host           = module.gke.endpoint
  kubernetes_token          = data.google_client_config.default.access_token
  kubernetes_ca_certificate = base64decode(module.gke.cluster_ca_certificate)

  app_name        = "productos-ms-app"
  container_image = "us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/productos-ms:v1"
  replicas        = 1
  service_name    = "productos-ms"
  productosdb_ip_address =  module.Database.productosdb_ip_address
  depends_on = [module.APIs, module.Database, module.docker_commands]
}