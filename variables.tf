variable "project_id" {
    type = string  
    description = "Identificador del proyecto en GCP"
}

variable "region" {
    type = string
    default = "region en la cual se va a desplegar el aplicativo"  
}

variable "db_usuarios"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de usuarios"
}

variable "db_empresas"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de empresas"
}

variable "db_proveedores"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de proveedores y productos"
}

variable "db_inventarios"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de inventarios"
}