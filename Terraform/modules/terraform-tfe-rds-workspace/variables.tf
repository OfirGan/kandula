##################################################################################
# Terraform Cloud
##################################################################################

variable "tfe_organization_name" {
  description = "Terrafrom Cloud Organization Name"
  type        = string
}

variable "tfe_vpc_workspace_name" {
  description = "Terrafrom Cloud vpc Workspace Name"
  type        = string
}

variable "tfe_rds_workspace_name" {
  type        = string
  description = "RDS Workspace Name for Backed State"
}

variable "tfe_github_oauth_token_id" {
  description = "Terraform Cloud GitHub Token ID"
  type        = string
  sensitive   = true
}

variable "auto_apply" {
  description = "Whether to automatically apply changes when a Terraform plan is successful"
  type        = bool
}


##################################################################################
# GitHub
##################################################################################

variable "github_user_name" {
  description = "Github User Name"
  type        = string
}

variable "github_workspace_repo_name" {
  description = "GitHub Workspace Repo name"
  type        = string
}

variable "github_branch" {
  description = "Github Workspace Branch Name"
  type        = string
}

variable "rds_workspace_directory" {
  description = "Working directory for rds module"
  type        = string
}

##################################################################################
# Slack Notifications
##################################################################################

variable "notification_triggers" {
  description = "Terraform Cloud Notification Triggers"
  # Options: https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration#triggers
  type = list(string)
}

variable "slack_notification_webhook_url" {
  description = "Slack Webhook URL for Notifications"
  type        = string
  sensitive   = true
}

##################################################################################
# RDS Workspace Environment Variables
##################################################################################

variable "aws_access_key_id" {
  description = "AWS Acess Key"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Acess Key"
  type        = string
  sensitive   = true
}

variable "aws_default_region" {
  description = "AWS Default Region"
  type        = string
}

##################################################################################
# RDS Workspace Variables
##################################################################################

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
