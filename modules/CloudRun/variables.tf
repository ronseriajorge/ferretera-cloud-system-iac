variable "region" {
    type = string  
}

variable "inventariodb_ip_address"{
    type = string
    description = "IP de la base de datos de inventarios"
}

variable "usuarios-ms-url"{
    type = string
    description = "URL del microservicio de usuarios"
}