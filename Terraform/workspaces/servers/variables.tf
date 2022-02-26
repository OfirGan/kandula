##################################################################################
# VARIABLES
##################################################################################

variable "tfe_organization_name" {
  description = "Terrafrom Cloud Organization Name"
  type        = string
}

variable "tfe_vpc_workspace_name" {
  description = "Terrafrom Cloud VPC Workspace Name"
  type        = string
}

variable "tfe_servers_workspace_name" {
  description = "Terrafrom Cloud VPC Workspace Name"
  type        = string
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
variable "aws_server_key_name" {
  description = "AWS EC2 Key pair Name"
}

variable "alb_certificate" {
  description = "Certificate PEM"
}

variable "alb_certificate_private_key" {
  description = "Certificate Private Key PEM"
}

