##################################################################################
# PROVIDERS
##################################################################################

terraform {
  backend "remote" {
    organization = var.tfe_organization_name

    workspaces {
      name = var.tfe_servers_workspace_name
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {}

