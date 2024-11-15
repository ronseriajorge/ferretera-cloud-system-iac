output "endpoint" {
  description = "El endpoint del cluster GKE"
  value       = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "El certificado del cluster GKE"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}