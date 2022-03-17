##################################################################################
# Workspace
##################################################################################

resource "tfe_workspace" "rds" {
  name                = var.tfe_rds_workspace_name
  organization        = var.tfe_organization_name
  auto_apply          = var.auto_apply
  execution_mode      = "remote"
  working_directory   = var.rds_workspace_directory
  global_remote_state = true
  queue_all_runs      = false

  vcs_repo {
    identifier     = "${var.github_user_name}/${var.github_workspace_repo_name}"
    oauth_token_id = var.tfe_github_oauth_token_id
    branch         = var.github_branch
  }
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
  workspace_id     = resource.tfe_workspace.rds.id
}

##################################################################################
# Workspace Environment Variables
##################################################################################

resource "tfe_variable" "aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  description  = "AWS Access Key ID"
  workspace_id = tfe_workspace.rds.id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  description  = "AWS Secret Access Key"
  workspace_id = tfe_workspace.rds.id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "aws_default_region" {
  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_default_region
  description  = "AWS Default Region ENV"
  workspace_id = tfe_workspace.rds.id
  category     = "env"
}

resource "tfe_variable" "tfe_rds_workspace_name" {
  key          = "tfe_rds_workspace_name"
  value        = var.tfe_rds_workspace_name
  description  = "RDS Workspace Name"
  workspace_id = tfe_workspace.rds.id
  category     = "env"
}

##################################################################################
# Workspace Variables
##################################################################################

resource "tfe_variable" "tfe_organization_name" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  description  = "TFE Organization Name"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

resource "tfe_variable" "tfe_vpc_workspace_name" {
  key          = "tfe_vpc_workspace_name"
  value        = var.tfe_vpc_workspace_name
  description  = "VPC Workspace Name"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

resource "tfe_variable" "db_engine_version" {
  key          = "engine_version"
  value        = var.db_engine_version
  description  = "DB Engine Version"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

resource "tfe_variable" "db_identifier_name" {
  key          = "db_identifier_name"
  value        = var.db_identifier_name
  description  = "DB Identifier name"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

resource "tfe_variable" "db_instance_class" {
  key          = "instance_class"
  value        = var.db_instance_class
  description  = "DB Instance class"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

resource "tfe_variable" "db_username" {
  key          = "db_username"
  value        = var.db_username
  description  = "DB Username"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

resource "tfe_variable" "db_password" {
  key          = "db_password"
  value        = var.db_password
  description  = "DB Password"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
  sensitive    = true
}

resource "tfe_variable" "db_ingress_ports" {
  key          = "db_password"
  value        = var.db_ingress_ports
  description  = "Postgres DB ingress ports"
  workspace_id = tfe_workspace.rds.id
  category     = "terraform"
}

