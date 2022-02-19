##################################################################################
# VPC
##################################################################################

module "vpc" {
  source  = "app.terraform.io/Kandula-OpsSchool-Project/vpc/aws"
  version = "1.0.1"

  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = var.availability_zones_count
  project_name             = var.project_name
}
