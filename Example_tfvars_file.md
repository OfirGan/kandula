## terraform.tfvars File
create terraform.tfvars using this template:
```
##################################################################################
# Terraform Cloud
##################################################################################
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

private_key_file_path = "C:\\Downloads\\OpsSchool\\Private-Keys\\Kandula_Private_Key.pem"

owner_name          = "ofir"
s3_logs_bucket_name = "ofirgan-kandula-alb-logs-bucket" # Must Be Uniq

##################################################################################
# Slack
##################################################################################
slack_notification_webhook_url = "https://hooks.slack.com/...."