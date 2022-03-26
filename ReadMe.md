# About
~~~
This Repo demonstrate automated creation of configured & resilient infrastructure to support application CI-CD cycle.

In this infrastructure:
* Bastion Host - Jump Host to Connect To The Servers
* Ansible Server - Configuration Management
* Consul Servers - Service Discovery
* Jenkins Server & Nodes - CI-CD
* Prometheus & Grafana - Monitoring
* Elasticsearch & Kibana - Logging
* RDS - App Database
* EKS - K8s Deployment

~~~

# Prerequisites
~~~
Fork Those Git Repos to your Github Account
* git@github.com:OfirGan/terraform-aws-vpc.git
* git@github.com:OfirGan/terraform-aws-servers.git
* git@github.com:OfirGan/terraform-aws-rds.git
* git@github.com:OfirGan/kandula.git

Configure your PC with:
* aws cli
* terraform + tfc cloud connection
* python3
    * boto3
    * scp
    * paramiko
    * json
    * re
    * requests
~~~

# How To Deploy:
~~~
* Clone kandula repo from your github to your pc
* Create terraform.tfvars According to "Example_tfvars_file.md" and replace it. 
    !!! Never Push terraform.tfvars To Github, It Has Your Secrets... !!!

* cd ./kandula
* python3 Deploy.py

~~~

# Jenkis Prerequisites
~~~

* Fork Repo git@github.com:OfirGan/kandula-project-app.git

* Edit jenkinsfile.groovy
    * docker_repository = "<yourOwnRepo>/kandula-app"
    * github_repo_ssh_Path = "git@github.com:<yourOwnRepo>/kandula-project-app.git"

~~~

# Manually Config Jenkis To Deploy App:
~~~

## Update Users (user & pass): (hard coded ids in https://github.com/OfirGan/kandula-project-app/blob/final-project/jenkinsfile.groovy)
* dockerhub.user (user & pass) - To Push Image to Dockerhub Repo
* github.user (ssh + key) - To Clone Kandula-App Repo
* aws.user (ssh + key) - To Add Jenkins Node

## Add Nodes:
* Relunch node

## kandula-cicd Pipeline:
* update Repository URL -> git@github.com:<yourOwnRepo>/kandula-project-app.git

~~~