##################################################################################
# PROVIDERS
##################################################################################

terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.27.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "tfe" {
  token = var.tfe_token
}

provider "aws" {
  region     = var.aws_default_region
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}
