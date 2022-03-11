variable "kubernetes_version" {
  default     = 1.21
  description = "kubernetes version"
}

variable "aws_region" {
  description = "aws region"
}

variable "cidr_blocks" {
  type        = list(string)
  description = "cidr blocks list"
  default = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

variable "k8s_service_account_namespace" {
  description = "Kubernetes Service Account Namespace"
}

variable "k8s_service_account_name" {
  description = "Kubernetes Service Account Name"
}

variable "tfe_organization_name" {
  type        = string
  description = "TFE Organization Name"
}

variable "tfe_vpc_workspace_name" {
  type        = string
  description = "VPC Workspace Name for Backed State"
}

variable "tfe_servers_workspace_name" {
  type        = string
  description = "Servers Workspace Name for Backed State"
}

variable "k8s_cluster_name" {
  type        = string
  description = "k8s Cluster Name"
}
