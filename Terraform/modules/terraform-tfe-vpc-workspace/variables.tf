##################################################################################
# Terraform Cloud
##################################################################################

variable "tfe_organization_name" {
  description = "Terrafrom Cloud Organization Name"
  type        = string
}

variable "tfe_vpc_workspace_name" {
  description = "Terrafrom Cloud VPC Workspace Name"
  type        = string
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

variable "vpc_workspace_directory" {
  description = "Working directory for vpc module"
  type        = string
}

variable "github_aws_vpc_module_repo_name" {
  description = "Github VPS AWS Module Repo Name"
  type        = string
}

##################################################################################
# Slack Notifications
##################################################################################

variable "notification_triggers" {
  # Options: https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration#triggers
  description = "Terraform Cloud Notification Triggers"
  type        = list(string)
}

variable "slack_notification_webhook_url" {
  description = "Slack Webhook URL for Notifications"
  type        = string
  sensitive   = true
}


##################################################################################
# VPC Workspace Environment Variables
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
# VPC Workspace Variables
##################################################################################

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "availability_zones_count" {
  description = "AZ Count to create subnets in"
  type        = number
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "tls_self_signed_cert_pem_content" {
  description = "Certificate PEM Content"
  sensitive   = true

}

variable "cert_private_key_pem_content" {
  description = "Certificate Private Key PEM Content"
  sensitive   = true
}
