output "service_ip" {
  description = "Dirección IP del servicio expuesto"
  value       = kubernetes_service.example_service.status[0].load_balancer[0].ingress[0].ip
}