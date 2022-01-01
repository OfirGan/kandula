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

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "availability_zones_count" {
  description = "AZ Count to create subnets in, needs to be <= amount of actual available AZs"
  type        = number
}

variable "project_name" {
  description = "Project Name"
  type        = string
}
