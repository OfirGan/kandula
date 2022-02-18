##################################################################################
# Registry Module
##################################################################################

resource "tfe_registry_module" "aws_servers_module" {
  vcs_repo {
    display_identifier = "${var.github_user_name}/${var.github_aws_servers_module_repo_name}"
    identifier         = "${var.github_user_name}/${var.github_aws_servers_module_repo_name}"
    oauth_token_id     = var.tfe_github_oauth_token_id
  }
}


##################################################################################
# Workspace
##################################################################################

resource "tfe_workspace" "servers_workspace" {
  name                = var.tfe_servers_workspace_name
  organization        = var.tfe_organization_name
  auto_apply          = var.auto_apply
  execution_mode      = "remote"
  working_directory   = var.servers_workspace_directory
  global_remote_state = true
  queue_all_runs      = false

  vcs_repo {
    identifier     = "${var.github_user_name}/${var.github_workspace_repo_name}"
    oauth_token_id = var.tfe_github_oauth_token_id
    branch         = var.github_branch
  }

  depends_on = [tfe_registry_module.aws_servers_module]
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
  workspace_id     = resource.tfe_workspace.servers_workspace.id
}


##################################################################################
# Workspace Environment Variables
##################################################################################

resource "tfe_variable" "aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  sensitive    = "true"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  description  = "AWS Connection"
}

resource "tfe_variable" "aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  sensitive    = "true"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  description  = "AWS Connection"
}

resource "tfe_variable" "aws_default_region" {
  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_default_region
  description  = "AWS Default Region"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "env"
}


##################################################################################
# Workspace Variables
##################################################################################

resource "tfe_variable" "tfe_organization_name" {
  key          = "tfe_organization_name"
  value        = var.tfe_organization_name
  description  = "Terrafrom Cloud Organization Name"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "tfe_vpc_workspace_name" {
  key          = "tfe_vpc_workspace_name"
  value        = var.tfe_vpc_workspace_name
  description  = "Terrafrom Cloud Servers Workspace Name"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "tfe_servers_workspace_name" {
  key          = "tfe_servers_workspace_name"
  value        = var.tfe_servers_workspace_name
  description  = "Terrafrom Cloud Servers Workspace Name"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  category     = "terraform"
}

#############################################
# S3 For logs
#############################################
resource "tfe_variable" "s3_logs_bucket_name" {
  key          = "s3_logs_bucket_name"
  value        = var.s3_logs_bucket_name
  description  = "Logs Bucket Name (lowercase only, no spaces)"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "elb_account_id" {
  key          = "elb_account_id"
  value        = var.elb_account_id
  description  = "ELB Account ID - pick one according to region https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}

#############################################
# Servers
#############################################
resource "tfe_variable" "instance_type" {
  key          = "instance_type"
  value        = var.instance_type
  description  = "Instances type"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "consul_servers_count" {
  key          = "consul_servers_count"
  value        = var.consul_servers_count
  description  = "How many Consul servers to create"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "jenkins_nodes_count" {
  key          = "jenkins_nodes_count"
  value        = var.jenkins_nodes_count
  description  = "How many Jenkins nodes to create"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}

#############################################
# Tags
#############################################
resource "tfe_variable" "project_name" {
  key          = "project_name"
  value        = var.project_name
  description  = "Project Name"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  category     = "terraform"
}

resource "tfe_variable" "owner_name" {
  key          = "owner_name"
  value        = var.owner_name
  description  = "Project Name"
  workspace_id = resource.tfe_workspace.servers_workspace.id
  category     = "terraform"
}

#############################################
# Keys
#############################################

resource "tfe_variable" "aws_server_key_name" {
  key          = "aws_server_key_name"
  value        = var.aws_server_key_name
  description  = "AWS EC2 Key pair Name"
  workspace_id = tfe_workspace.servers_workspace.id
  category     = "terraform"
}
