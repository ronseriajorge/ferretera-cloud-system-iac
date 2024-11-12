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