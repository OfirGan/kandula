##################################################################################
# Workspace
##################################################################################

resource "tfe_workspace" "kubernetes" {
  name                = var.tfe_kubernetes_workspace_name
  organization        = var.tfe_organization_name
  auto_apply          = var.auto_apply
  execution_mode      = "remote"
  working_directory   = var.kubernetes_workspace_directory
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
  workspace_id     = resource.tfe_workspace.kubernetes.id
}

##################################################################################
# Workspace Environment Variables
##################################################################################

resource "tfe_variable" "aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  description  = "AWS Access Key ID"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  description  = "AWS Secret Access Key"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "env"
  sensitive    = true
}

resource "tfe_variable" "aws_default_region" {
  key          = "AWS_DEFAULT_REGION"
  value        = var.aws_default_region
  description  = "AWS Default Region ENV"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "env"
}

resource "tfe_variable" "tfe_kubernetes_workspace_name" {
  key          = "tfe_kubernetes_workspace_name"
  value        = var.tfe_kubernetes_workspace_name
  description  = "K8s Workspace Name"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "env"
}

##################################################################################
# Workspace Variables
##################################################################################

resource "tfe_variable" "aws_region" {
  key          = "aws_region"
  value        = var.aws_default_region
  description  = "AWS Default Region TF var"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

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
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

resource "tfe_variable" "k8s_cluster_name" {
  key          = "k8s_cluster_name"
  value        = var.k8s_cluster_name
  description  = "Kubernetes Cluster Name"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

resource "tfe_variable" "k8s_service_account_namespace" {
  key          = "k8s_service_account_namespace"
  value        = var.k8s_service_account_namespace
  description  = "Kubernetes Service Account Namespace"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

resource "tfe_variable" "k8s_service_account_name" {
  key          = "k8s_service_account_name"
  value        = var.k8s_service_account_name
  description  = "Kubernetes Service Account Name"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
}

resource "tfe_variable" "db_password" {
  key          = "db_password"
  value        = var.db_password
  description  = "DB Password"
  workspace_id = tfe_workspace.kubernetes.id
  category     = "terraform"
  sensitive    = true
}
