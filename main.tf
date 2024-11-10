provider "google" {
  project =  var.project_id
  region  = var.region
}

module "APIs" {
  source     = "./modules/Apis"
  project_id =  var.project_id
}