##################################################################################
# PROVIDERS
##################################################################################

terraform {
  required_version = "1.0.11"

  backend "remote" {
    organization = var.tfe_organization_name

    workspaces {
      name = var.tfe_vpc_workspace_name
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
