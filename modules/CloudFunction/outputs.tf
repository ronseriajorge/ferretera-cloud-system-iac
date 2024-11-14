output "url-usuarios-ms" {
  value = google_cloudfunctions2_function.usuarios_ms.service_config[0].uri
}