##################################################################################
# DATA SOURCE
##################################################################################

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.tfe_organization_name
    workspaces = {
      name = var.tfe_vpc_workspace_name
    }
  }
}

##################################################################################
# RDS
##################################################################################

module "rds" {
  source  = "app.terraform.io/Kandula-Project/rds/aws"
  version = "1.0.2"

  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  db_subnet_ids        = data.terraform_remote_state.vpc.outputs.public_subnets_ids
  route53_zone_zone_id = data.terraform_remote_state.vpc.outputs.route53_zone_zone_id
  db_engine_version    = var.db_engine_version
  db_identifier_name   = var.db_identifier_name
  db_instance_class    = var.db_instance_class
  db_username          = var.db_username
  db_password          = var.db_password
}
