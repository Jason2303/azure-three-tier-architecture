variable "name" {
  default  = "three-tier-architecture"
  type = string
}

variable "region" {
  default  = "West Europe"
  type = string
}

variable "postgres_admin_username" {
  type        = string
  description = "Administrator username for PostgreSQL Flexible Server"
}

variable "postgres_admin_password" {
  type        = string
  description = "Administrator password for PostgreSQL Flexible Server"
  sensitive   = true
}