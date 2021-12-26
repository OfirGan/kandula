# Prerequisites

## Terraform Cloud
* Organization name

---

## GitHub
* Organization Name
* Personal Access Token
* Workspaces:
    * Workspaces Repository Name
    * VPC Workspace - VCS Repo Workinkg Directory (/working/dir)
    * EC2 Workspace - VCS Repo Workinkg Directory (/working/dir)
* Modules:
    * VPC Module Repository Name (path/to/module)
    * EC2 Module Repository Name (path/to/module)

---

## AWS
* AWS Acess Key 
* AWS Secret Acess Key
* Region Name

---

## Slack
*  slack notification webhook url


## terraform.tfvars File
create terraform.tfvars using this template:
```
##################################################################################
# Terraform Cloud
##################################################################################
tfe_organization_name = "<Terraform Cloud Organization Name>"
tfe_organization_email = "XXXXX@gmail.com"

##################################################################################
# Github
##################################################################################
vcs_organization_name        = "<Github UserName>"
vcs_personal_access_token    = "XXXXXXXXXXXX"
vcs_workspace_repo_name      = "<Workspace Repo Name>"
vpc_workspace_repo_directory = "/working/dir"
ec2_workspace_repo_directory = "/working/dir"
vpc_tfe_module_github_path   = "terraform-tfe-vpc"
ec2_tfe_module_github_path   = "terraform-tfe-ec2"
vpc_aws_module_github_path   = "terraform-aws-vpc"
ec2_aws_module_github_path   = "terraform-aws-ec2"

##################################################################################
# AWS
##################################################################################
aws_acess_key_id     = "XXXXXX"
aws_secret_acess_key = "XXXXXX"
aws_default_region   = "us-east-1"

owner_name  = "Owner"
purpose_tag = "Purpose"

##################################################################################
# AWS VPC
##################################################################################
vpc_cidr                 = "10.0.0.0/16"
availability_zones_count = 2

##################################################################################
# AWS EC2
##################################################################################
aws_ec2_key_pair_name = "key-pair-name"
instance_count        = 2
instance_type         = "t2.micro"
s3_logs_bucket_name   = "bucket-name"
s3_logs_folder        = "hw4"

##################################################################################
# Slack
##################################################################################
notification_triggers          = ["run:completed"]
slack_notification_webhook_url = "https://hooks.slack.com/services/...."
```