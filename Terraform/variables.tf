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
  default     = "vpc-workspace"
}

variable "tfe_servers_workspace_name" {
  description = "Terrafrom Cloud Servers Workspace Name"
  type        = string
  default     = "servers-workspace"
}

variable "tfe_kubernetes_workspace_name" {
  description = "Terrafrom Cloud Kubernetes Workspace Name"
  type        = string
  default     = "kubernetes-workspace"
}

variable "tfe_rds_workspace_name" {
  description = "Terrafrom Cloud rds Workspace Name"
  type        = string
  default     = "rds-workspace"
}

variable "tfe_organization_email" {
  description = "Terraform Cloud Organization Email"
  type        = string
}

variable "auto_apply" {
  description = "Whether to automatically apply changes when a Terraform plan is successful"
  type        = bool
  default     = false
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
  default     = "kandula"
}

variable "github_branch" {
  description = "Github Workspace Branch Name"
  type        = string
}

variable "vpc_workspace_directory" {
  description = "Working directory for vpc module"
  type        = string
  default     = "/Terraform/workspaces/vpc"
}

variable "servers_workspace_directory" {
  description = "Working directory for Servers module"
  type        = string
  default     = "/Terraform/workspaces/servers"
}

variable "kubernetes_workspace_directory" {
  description = "Working directory for Kubernetes module"
  type        = string
  default     = "/Terraform/workspaces/kubernetes"
}

variable "rds_workspace_directory" {
  description = "Working directory for RDS module"
  type        = string
  default     = "/Terraform/workspaces/rds"
}

variable "github_aws_vpc_module_repo_name" {
  description = "Github VPC AWS Module Repo Name"
  type        = string
  default     = "terraform-aws-vpc"
}

variable "github_aws_servers_module_repo_name" {
  description = "Github Servers AWS Module Repo Name"
  type        = string
  default     = "terraform-aws-servers"
}

variable "github_aws_rds_module_repo_name" {
  description = "Github RDS AWS Module Repo Name"
  type        = string
  default     = "terraform-aws-rds"
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
  default     = "us-east-1"
  # If edit -> update variable "elb_account_id" to match aws region
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones_count" {
  description = "AZ Count to create subnets in, needs to be <= amount of actual available AZs"
  type        = number
  default     = 2
}

##################################################################################
# S3 For logs
##################################################################################
variable "s3_logs_bucket_name" {
  description = "Logs Bucket Name (lowercase only, no spaces)"
  type        = string
}

variable "elb_account_id" {
  description = "ELB Account ID"
  type        = string
  default     = "127311923021"
  # pick one according to region 
  # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
}

##################################################################################
# Servers
##################################################################################
variable "instance_type" {
  description = "Servers Instance Type"
  type        = string
  default     = "t3.small"
}

variable "consul_servers_count" {
  description = "How many Consul servers to create"
  type        = number
  default     = 3
}

variable "jenkins_nodes_count" {
  description = "How many Jenkins nodes to create"
  type        = number
  default     = 2
}

##################################################################################
# Tags
##################################################################################
variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "kandula"
}

variable "owner_name" {
  description = "Owner Name"
  type        = string
}

##################################################################################
# Keys
##################################################################################
variable "private_key_folder_path" {
  type        = string
  description = "Private Key Folder Path"
}

##################################################################################
# Slack
##################################################################################

variable "notification_triggers" {
  # Options: https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/notification_configuration#triggers
  description = "Terraform Cloud Notification Triggers"
  type        = list(string)
  default     = ["run:completed"]
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
  default     = "k8s-kandula-cluster"
}

variable "k8s_service_account_namespace" {
  type        = string
  description = "k8s Application Namespace"
  default     = "default"
}

variable "k8s_service_account_name" {
  type        = string
  description = "k8s Application Service Account"
  default     = "kandula-sa"
}


##################################################################################
# RDS
##################################################################################

variable "db_engine_version" {
  type        = string
  description = "DB Engine Version"
  default     = "12.10"
}

variable "db_identifier_name" {
  type        = string
  description = "DB Identifier name"
  default     = "kandula-db"
}

variable "db_instance_class" {
  type        = string
  description = "DB Instance class"
  default     = "db.t2.micro"
}

variable "db_username" {
  type        = string
  description = "DB Username"
  default     = "postgres"
}

variable "db_password" {
  type        = string
  description = "DB Password"
  # Only printable ASCII characters besides '/', '@', '"', ' ' may be used
}
