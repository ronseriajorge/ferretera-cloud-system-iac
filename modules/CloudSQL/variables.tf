variable "region" {
    type = string
    default = "us-east4"  
}

variable "db_empresas"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de empresas"
    default = "empresasdb"  
}

variable "db_proveedores"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de proveedores y productos"
    default = "productosdb"  
}

variable "db_inventarios"{
    type = string
    description = "nombre de la base de datos utilizada para la gestion de inventarios"
    default = "inventariosdb"  
}