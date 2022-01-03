# How To Deploy:
~~~
* Create terraform.tfvars using the "Example_tfvars_file.txt" in the same directory of the Deploy.py file
* Fill it with all the necessary data

* python3 Deploy.py (it will pause)

* Go to Terraform Cloud:
    * Apply vpc -> servers -> kubernetes

* After that continue running the script (enter yes)
~~~


# Manually Config Jenkis:

~~~
## Create Users: (hard coded ids in Jenkins/Jenkinsfile.groovy)
* dockerhub.ofirgan (user & pass) 
* github.ofirgan (ssh + key)
* aws.ubuntu (ssh + key) 

## Create Secret Text: (hard coded ids in Jenkins/Jenkinsfile.groovy)
* aws.access_key -> from terraform.tfvars
* aws.secret_key -> from terraform.tfvars
* aws.region -> from terraform.tfvars

## Add Nodes:
* Name -> Node1..
* Remote root directory -> /home/ubuntu/jenkins_home
* Labels -> docker (hard coded ids in Jenkins/Jenkinsfile.groovy)
* Launch method -> SSH (aws.ubuntu)
* Host Key Verification Strategy -> none

## Create Pipeline:
* SCM -> Git
* Repository URL -> git@github.com:OfirGan/kandula.git
* Credentials -> github
* Branch -> mid-project
* Script Path -> Jenkins/Jenkinsfile.groovy

* run piplin 2 (first will fail due to params config)
~~~

# Prerequisites
~~~

* aws cli configured
* terraform + tfc cloud connection
* python3
    * boto3
    * scp
    * paramiko
    * re

## Terraform Cloud
* Organization name
* organization_email
* Api token


## GitHub
* Organization Name
* Personal Access Token
* Workspaces:
    * Workspaces Repository Name
    * VPC Workspace - VCS Repo Workinkg Directory (/working/dir)
    * SERVERs Workspace - VCS Repo Workinkg Directory (/working/dir)
    
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
~~~