variable "kubernetes_host" {
  type = string
}

variable "kubernetes_token" {
  type = string
}

variable "kubernetes_ca_certificate" {
  type = string
}

variable "app_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "replicas" {
  type    = number
  default = 3
}

variable "service_name" {
  type = string
}
variable "productosdb_ip_address"{
    type = string
    description = "IP de la base de datos de inventarios"
}