# modules/apis/main.tf
resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
}

resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "firestore" {
  project = var.project_id
  service = "firestore.googleapis.com"
}

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

# Habilita la API de Cloud Functions
resource "google_project_service" "cloudfunctions" {
  project = var.project_id
  service = "cloudfunctions.googleapis.com"
}

# Habilita la API de Cloud Storage para almacenar el código de la función
resource "google_project_service" "storage" {
  project = var.project_id
  service = "storage.googleapis.com"
  disable_dependent_services = true
}

# Habilita la API de Cloud build
resource "google_project_service" "cloudbuild" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_iam_member" "compute_service_account_logging" {
  project = var.project_id  
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:511845341063-compute@developer.gserviceaccount.com"
}

resource "google_project_service" "kubernetes_engine" {
  project = var.project_id 
  service = "container.googleapis.com"

}