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

variable "tfe_servers_workspace_name" {
  description = "Terrafrom Cloud Servers Workspace Name"
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

variable "servers_workspace_directory" {
  description = "Working directory for vpc module"
  type        = string
}

variable "github_aws_servers_module_repo_name" {
  description = "Github VPS AWS Module Repo Name"
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
# Servers Workspace Environment Variables
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
# Servers Workspace Variables
##################################################################################

#############################################
# S3 For logs
#############################################
variable "s3_logs_bucket_name" {
  description = "Logs Bucket Name (lowercase only, no spaces)"
  type        = string
}

variable "elb_account_id" {
  description = "ELB Account ID - pick one according to region https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions"
  type        = string
}

#############################################
# Servers
#############################################
variable "instance_type" {
  description = "Servers Instance Type"
  type        = string
}

variable "consul_servers_count" {
  description = "How much Consul servers to create"
  type        = number
}

variable "jenkins_nodes_count" {
  description = "How much Jenkins nodes to create"
  type        = number
}

#############################################
# Tags
#############################################
variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "owner_name" {
  description = "Owner Name"
  type        = string
}

#############################################
# Keys
#############################################
variable "aws_server_key_name" {
  description = "AWS EC2 Key pair Name"
  type        = string
}
