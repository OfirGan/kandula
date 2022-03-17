##################################################################################
# VARIABLES
##################################################################################

variable "tfe_organization_name" {
  description = "Terrafrom Cloud Organization Name"
  type        = string
}

variable "tfe_vpc_workspace_name" {
  description = "Terrafrom Cloud VPC Workspace Name"
  type        = string
}

variable "db_engine_version" {
  type        = string
  description = "DB Engine Version"
}

variable "db_identifier_name" {
  type        = string
  description = "DB Identifier name"
}

variable "db_instance_class" {
  type        = string
  description = "DB Instance class"
}

variable "db_username" {
  type        = string
  description = "DB Username"
}

variable "db_password" {
  type        = string
  description = "DB Password"
}

variable "db_ingress_ports" {
  type        = list(number)
  description = "Postgres RDS ingress ports"
}

