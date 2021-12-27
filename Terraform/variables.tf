##################################################################################
# Terraform Cloud
##################################################################################

variable "tfe_token" {
  description = "Terraform Cloud Token"
  type        = string
}

variable "tfe_organization_name" {
  description = "Terraform Cloud Organization Name"
  type        = string
}

variable "tfe_vpc_workspace_name" {
  description = "Terrafrom Cloud VPC Workspace Name"
  type        = string
}

variable "tfe_servers_workspace_name" {
  description = "Terrafrom Cloud Servers Workspace Name"
  type        = string
}

variable "tfe_kubernetes_workspace_name" {
  description = "Terrafrom Cloud Kubernetes Workspace Name"
  type        = string
}


variable "tfe_organization_email" {
  description = "Terraform Cloud Organization Email"
  type        = string
}

variable "auto_apply" {
  description = "Whether to automatically apply changes when a Terraform plan is successful"
  type        = bool
}

##################################################################################
# Github
##################################################################################

variable "github_personal_access_token" {
  default = "Github Personal Acess Token to Workspaces Repo"
  type    = string
}

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

variable "servers_workspace_directory" {
  description = "Working directory for Servers module"
  type        = string
}

variable "kubernetes_workspace_directory" {
  description = "Working directory for Kubernetes module"
  type        = string
}


variable "github_aws_vpc_module_repo_name" {
  description = "Github VPS AWS Module Repo Name"
  type        = string
}

variable "github_aws_servers_module_repo_name" {
  description = "Github VPS AWS Module Repo Name"
  type        = string
}

##################################################################################
# AWS
##################################################################################
variable "aws_access_key_id" {
  description = "AWS Acess Key"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Acess Key"
  type        = string
}

variable "aws_default_region" {
  description = "AWS Default Region"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "availability_zones_count" {
  description = "AZ Count to create subnets in, needs to be <= amount of actual available AZs"
  type        = number
}

##################################################################################
# S3 For logs
##################################################################################
variable "s3_logs_bucket_name" {
  description = "Logs Bucket Name (lowercase only, no spaces)"
  type        = string
}

variable "elb_account_id" {
  description = "ELB Account ID - pick one according to region https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions"
  type        = string
}

##################################################################################
# Servers
##################################################################################
variable "instance_type" {
  description = "Servers Instance Type"
  type        = string
}

variable "consul_servers_count" {
  description = "How many Consul servers to create"
  type        = number
}

variable "jenkins_nodes_count" {
  description = "How many Jenkins nodes to create"
  type        = number
}

##################################################################################
# Tags
##################################################################################
variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "owner_name" {
  description = "Owner Name"
  type        = string
}

##################################################################################
# Keys
##################################################################################
variable "private_key_file_path" {
  type        = string
  description = "Private Key File Path"
}

##################################################################################
# Slack
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
# Kubernetes
##################################################################################

variable "k8s_cluster_name" {
  type        = string
  description = "k8s Cluster Name"
}

variable "k8s_service_account_namespace" {
  type        = string
  description = "k8s Application Namespace"
}

variable "k8s_service_account_name" {
  type        = string
  description = "k8s Application Service Account"
}

