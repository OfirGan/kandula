## terraform.tfvars File
create terraform.tfvars using this template:
```
##################################################################################
# Terraform Cloud
##################################################################################
tfe_organization_name         = "Kandula-OpsSchool-OfirGan" ## hard coded in -> workspaces folder -> main.tf -> module source ##
tfe_organization_email        = "user@gmail.com"
tfe_token                     = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

##################################################################################
# Github
##################################################################################
github_personal_access_token = "xxxxxxxxxxxxxxxxxxx"
github_user_name             = "ofirgan"

##################################################################################
# AWS Global
##################################################################################
aws_access_key_id     = "xxxxxxxxxx"
aws_secret_access_key = "xxxxxxxxx"
aws_default_region    = "us-east-1"
elb_account_id        = "127311923021"
# ELB Account ID - pick one according to region https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions

private_key_file_path = "C:\\Downloads\\OpsSchool\\Private-Keys\\Kandula_Private_Key.pem"

owner_name          = "ofir"
instance_type       = "t2.micro"
s3_logs_bucket_name = "ofirgan-kandula-alb-logs-bucket" # Must Be Uniq

##################################################################################
# Slack
##################################################################################
slack_notification_webhook_url = "https://hooks.slack.com/...."