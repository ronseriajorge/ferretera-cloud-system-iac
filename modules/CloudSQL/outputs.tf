output "inventariodb_ip_address" {
  value = google_sql_database_instance.inventarios-db.ip_address[0].ip_address
}