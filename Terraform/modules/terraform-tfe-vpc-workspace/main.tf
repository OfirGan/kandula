##################################################################################
# Registry Module
##################################################################################

resource "tfe_registry_module" "aws_vpc_module" {
  vcs_repo {
    display_identifier = "${var.github_user_name}/${var.github_aws_vpc_module_repo_name}"
    identifier         = "${var.github_user_name}/${var.github_aws_vpc_module_repo_name}"
    oauth_token_id     = var.tfe_github_oauth_token_id
  }
}


##################################################################################
# Workspace
##################################################################################

resource "tfe_workspace" "vpc_workspace" {
  name                = var.tfe_vpc_workspace_name
  organization        = var.tfe_organization_name
  auto_apply          = var.auto_apply
  execution_mode      = "remote"
  working_directory   = var.vpc_workspace_directory
  global_remote_state = true
  queue_all_runs      = false

  vcs_repo {
    identifier     = "${var.github_user_name}/${var.github_workspace_repo_name}"
    branch         = var.github_branch
    oauth_token_id = var.tfe_github_oauth_token_id
  }

  depends_on = [tfe_registry_module.aws_vpc_module]
}


##################################################################################
# Slack Notification
##################################################################################

resource "tfe_notification_configuration" "slac_notification" {
  name             = "Slac Notification"
  enabled          = false
  destination_type = "slack"
  triggers         = var.notification_triggers
  url              = var.slack_notification_webhook_url
  workspace_id     = resource.tfe_workspace.vpc_workspace.id
}


##################################################################################
# Workspace Environment Variables
##################################################################################

resource "tfe_variable" "aws_access_key_id" {
  description  = "AWS Connection"
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  sensitive    = "true"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
}

resource "tfe_variable" "aws_secret_access_key" {
  description  = "AWS Connection"
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  sensitive    = "true"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
}

resource "tfe_variable" "aws_default_region" {
  description  = "AWS Default Region"
  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_default_region
  category     = "env"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
}


##################################################################################
# Workspace Variables
##################################################################################

resource "tfe_variable" "tfe_organization_name" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  description  = "Terrafrom Cloud Organization Name"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "tfe_vpc_workspace_name" {
  key          = "tfe_vpc_workspace_name"
  value        = var.tfe_vpc_workspace_name
  description  = "Terrafrom Cloud VPC Workspace Name"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "vpc_cidr" {
  key          = "vpc_cidr"
  value        = var.vpc_cidr
  description  = "VPC CIDR"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "availability_zones_count" {
  key          = "availability_zones_count"
  value        = var.availability_zones_count
  description  = "AZ Count to create subnets in"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "project_name" {
  key          = "project_name"
  value        = var.project_name
  description  = "Project Name"
  workspace_id = resource.tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "tls_self_signed_cert_pem_content" {
  key          = "tls_self_signed_cert_pem_content"
  value        = var.tls_self_signed_cert_pem_content
  sensitive    = "true"
  description  = "Certificate PEM Content"
  workspace_id = tfe_workspace.vpc_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "cert_private_key_pem_content" {
  key          = "cert_private_key_pem_content"
  value        = var.cert_private_key_pem_content
  sensitive    = "true"
  description  = "Certificate Private Key PEM Content"
  workspace_id = tfe_workspace.vpc_workspace.id
  category     = "terraform"
}
