variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "initial_node_count" {
  type = number
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}