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
# Servers
##################################################################################

module "servers" {
  source  = "app.terraform.io/Kandula-OpsSchool-Project/servers/aws"
  version = "1.0.1"

  vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets_ids  = data.terraform_remote_state.vpc.outputs.public_subnets_ids
  private_subnets_ids = data.terraform_remote_state.vpc.outputs.private_subnets_ids

  s3_logs_bucket_name = var.s3_logs_bucket_name
  elb_account_id      = var.elb_account_id

  instance_type        = var.instance_type
  consul_servers_count = var.consul_servers_count
  jenkins_nodes_count  = var.jenkins_nodes_count

  project_name = var.project_name
  owner_name   = var.owner_name

  aws_server_key_name = var.aws_server_key_name

  aws_iam_server_certificate_arn             = data.terraform_remote_state.vpc.outputs.aws_iam_server_certificate_arn
  ec2_describe_instances_instance_profile_id = data.terraform_remote_state.vpc.outputs.ec2_describe_instances_instance_profile_id
}
