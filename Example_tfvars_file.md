## terraform.tfvars File
create terraform.tfvars using this template:
```
##################################################################################
# Terraform Cloud
##################################################################################
tfe_organization_name  = "Kandula-Project" ## hard coded in -> workspaces folder -> main.tf -> module source ##
tfe_organization_email = "user@gmail.com"
tfe_token              = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

##################################################################################
# Github
##################################################################################
github_personal_access_token = "xxxxxxxxxxxxxxxxxxx"
github_user_name             = "ofirgan"
github_branch                = "final-project"

##################################################################################
# AWS Global
##################################################################################
aws_access_key_id     = "xxxxxxxxxx"
aws_secret_access_key = "xxxxxxxxx"
aws_default_region    = "us-east-1" 
# If edit -> update variable "elb_account_id" to match aws region

elb_account_id = "127311923021" 
# pick one according to region https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions"

private_key_file_path = "C:\\Downloads\\OpsSchool\\Private-Keys\\Kandula_Private_Key.pem"

owner_name          = "ofir"
s3_logs_bucket_name = "ofirgan-kandula-alb-logs-bucket" # Must Be Uniq

db_password = "xxxxxxxx"
# Only printable ASCII characters besides '/', '@', '"', ' ' may be used

##################################################################################
# Slack
##################################################################################
slack_notification_webhook_url = "https://hooks.slack.com/...."