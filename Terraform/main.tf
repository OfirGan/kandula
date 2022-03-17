##################################################################################
# Organization
##################################################################################

resource "tfe_organization" "organization" {
  name  = var.tfe_organization_name
  email = var.tfe_organization_email
}

##################################################################################
# OAuth Token
##################################################################################

resource "tfe_oauth_client" "github_tfe_oauth_token" {
  organization     = var.tfe_organization_name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_personal_access_token
  service_provider = "github"

  depends_on = [tfe_organization.organization]
}

##################################################################################
# SSH Keys
##################################################################################

resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "server_key" {
  key_name   = "${var.project_name}_server_key"
  public_key = tls_private_key.server_key.public_key_openssh
}

resource "local_file" "server_key" {
  content  = tls_private_key.server_key.private_key_pem
  filename = "${var.private_key_folder_path}Kandula_Server_Private_Key.pem"
}

##################################################################################
# CA CERTIFICATE
##################################################################################

resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "certificate" {
  key_algorithm     = tls_private_key.ca_key.algorithm
  private_key_pem   = tls_private_key.ca_key.private_key_pem
  is_ca_certificate = true

  validity_period_hours = "17520" # 2 Years
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]

  subject {
    common_name  = "Kandula Certificate"
    organization = "Kandula"
  }
}

resource "local_file" "certificate_private_key" {
  content  = tls_private_key.ca_key.private_key_pem
  filename = "${var.private_key_folder_path}Kandula_Certificat_Private_key.pem"
}

resource "local_file" "certificate" {
  content  = tls_self_signed_cert.certificate.cert_pem
  filename = "${var.private_key_folder_path}Kandula_Self_Signed_Certificat.pem"
}

data "local_file" "certificate_private_key" {
  filename   = "${var.private_key_folder_path}Kandula_Certificat_Private_key.pem"
  depends_on = [resource.local_file.certificate_private_key]
}

data "local_file" "certificate" {
  filename   = "${var.private_key_folder_path}Kandula_Self_Signed_Certificat.pem"
  depends_on = [resource.local_file.certificate]
}

##################################################################################
# Workspace
##################################################################################

module "vpc_tfe_module" {
  source = ".\\modules\\terraform-tfe-vpc-workspace"

  tfe_organization_name          = var.tfe_organization_name
  tfe_vpc_workspace_name         = var.tfe_vpc_workspace_name
  tfe_github_oauth_token_id      = resource.tfe_oauth_client.github_tfe_oauth_token.oauth_token_id
  notification_triggers          = var.notification_triggers
  slack_notification_webhook_url = var.slack_notification_webhook_url
  auto_apply                     = var.auto_apply

  github_user_name                = var.github_user_name
  github_workspace_repo_name      = var.github_workspace_repo_name
  github_branch                   = var.github_branch
  vpc_workspace_directory         = var.vpc_workspace_directory
  github_aws_vpc_module_repo_name = var.github_aws_vpc_module_repo_name

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_default_region    = var.aws_default_region

  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = var.availability_zones_count
  project_name             = var.project_name

  cert_private_key_pem_content     = data.local_file.certificate_private_key.content
  tls_self_signed_cert_pem_content = data.local_file.certificate.content
}

module "servers_tfe_module" {
  source = ".\\modules\\terraform-tfe-servers-workspace"

  tfe_organization_name          = var.tfe_organization_name
  tfe_vpc_workspace_name         = var.tfe_vpc_workspace_name
  tfe_servers_workspace_name     = var.tfe_servers_workspace_name
  tfe_github_oauth_token_id      = resource.tfe_oauth_client.github_tfe_oauth_token.oauth_token_id
  notification_triggers          = var.notification_triggers
  slack_notification_webhook_url = var.slack_notification_webhook_url
  auto_apply                     = var.auto_apply

  github_user_name                    = var.github_user_name
  github_workspace_repo_name          = var.github_workspace_repo_name
  github_branch                       = var.github_branch
  servers_workspace_directory         = var.servers_workspace_directory
  github_aws_servers_module_repo_name = var.github_aws_servers_module_repo_name

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_default_region    = var.aws_default_region

  s3_logs_bucket_name = var.s3_logs_bucket_name
  elb_account_id      = var.elb_account_id

  instance_type        = var.instance_type
  consul_servers_count = var.consul_servers_count
  jenkins_nodes_count  = var.jenkins_nodes_count

  aws_server_key_name = aws_key_pair.server_key.key_name

  project_name = var.project_name
  owner_name   = var.owner_name

  depends_on = [module.vpc_tfe_module]
}

module "kubernetes_tfe_module" {
  source = ".\\modules\\terraform-tfe-kubernetes-workspace"

  tfe_organization_name          = var.tfe_organization_name
  tfe_vpc_workspace_name         = var.tfe_vpc_workspace_name
  tfe_kubernetes_workspace_name  = var.tfe_kubernetes_workspace_name
  tfe_github_oauth_token_id      = resource.tfe_oauth_client.github_tfe_oauth_token.oauth_token_id
  notification_triggers          = var.notification_triggers
  slack_notification_webhook_url = var.slack_notification_webhook_url
  auto_apply                     = var.auto_apply

  github_user_name               = var.github_user_name
  github_workspace_repo_name     = var.github_workspace_repo_name
  github_branch                  = var.github_branch
  kubernetes_workspace_directory = var.kubernetes_workspace_directory

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_default_region    = var.aws_default_region

  k8s_cluster_name              = var.k8s_cluster_name
  k8s_service_account_namespace = var.k8s_service_account_namespace
  k8s_service_account_name      = var.k8s_service_account_name

  depends_on = [module.vpc_tfe_module]
}

module "rds_tfe_module" {
  source = ".\\modules\\terraform-tfe-rds-workspace"

  tfe_organization_name          = var.tfe_organization_name
  tfe_vpc_workspace_name         = var.tfe_vpc_workspace_name
  tfe_rds_workspace_name         = var.tfe_rds_workspace_name
  tfe_github_oauth_token_id      = resource.tfe_oauth_client.github_tfe_oauth_token.oauth_token_id
  notification_triggers          = var.notification_triggers
  slack_notification_webhook_url = var.slack_notification_webhook_url
  auto_apply                     = var.auto_apply

  github_user_name                = var.github_user_name
  github_workspace_repo_name      = var.github_workspace_repo_name
  github_branch                   = var.github_branch
  rds_workspace_directory         = var.rds_workspace_directory
  github_aws_rds_module_repo_name = var.github_aws_rds_module_repo_name


  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
  aws_default_region    = var.aws_default_region

  db_engine_version  = var.db_engine_version
  db_identifier_name = var.db_identifier_name
  db_instance_class  = var.db_instance_class
  db_username        = var.db_username
  db_password        = var.db_password

  depends_on = [module.vpc_tfe_module]
}


##################################################################################
# Workspace Triggers
##################################################################################

# resource "tfe_run_trigger" "servers_auto_run_after_vpc" {
#   workspace_id  = module.servers_tfe_module.workspace_id
#   sourceable_id = module.vpc_tfe_module.workspace_id
# }

# resource "tfe_run_trigger" "kubernetes_auto_run_after_servers" {
#   workspace_id  = module.kubernetes_tfe_module.workspace_id
#   sourceable_id = module.servers_tfe_module.workspace_id
# }
