provider "google" {
  project =  var.project_id
  region  = var.region
}

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