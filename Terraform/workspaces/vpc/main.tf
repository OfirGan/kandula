##################################################################################
# VPC
##################################################################################

module "vpc" {
  source  = "app.terraform.io/Kandula-Project/vpc/aws"
  version = "1.0.1"

  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = var.availability_zones_count
  project_name             = var.project_name

  tls_self_signed_cert_pem_content = var.tls_self_signed_cert_pem_content
  cert_private_key_pem_content     = var.cert_private_key_pem_content
}
