##################################################################################
# DATA SOURCE
##################################################################################

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = var.tfe_organization_name
    workspaces = {
      name = var.tfe_servers_workspace_name
    }
  }
}

##################################################################################
# Servers
##################################################################################

module "servers" {
  source  = "app.terraform.io/${var.tfe_organization_name}/servers/aws"
  version = "1.0.0"




  vpc_id               = data.terraform_remote_state.vpc.outputs.vpc_id
  available_zone_names = data.terraform_remote_state.vpc.outputs.available_zone_names
  s3_logs_bucket_name  = var.s3_logs_bucket_name
  s3_logs_folder       = var.s3_logs_folder
  public_subnets_ids   = data.terraform_remote_state.vpc.outputs.public_subnets_ids
  private_subnets_ids  = data.terraform_remote_state.vpc.outputs.private_subnets_ids
  instance_count       = var.instance_count
  instance_type_web    = var.instance_type
  instance_type_db     = var.instance_type
  key_name             = aws_ec2_key_pair_name
  purpose_tag          = var.purpose_tag
  owner_tag            = var.owner_tag
}
