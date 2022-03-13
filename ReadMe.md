# Prerequisites
~~~
Fork Those Git Repos to your Github Account
* git@github.com:OfirGan/terraform-aws-vpc.git
* git@github.com:OfirGan/terraform-aws-servers.git
* git@github.com:OfirGan/kandula.git

Configure your PC with:
* aws cli
* terraform + tfc cloud connection
* python3
    * boto3
    * scp
    * paramiko
    * re
~~~

# How To Deploy:
~~~
* Clone kandula repo from your github to your pc
* Create terraform.tfvars According to "Example_tfvars_file.md" and replace it. 
    !!! Never Push terraform.tfvars To Github, Its Your Secrets... !!!

* cd ./kandula
* python3 Deploy.py (it will pause)

~~~


# Jenkis Prerequisites
~~~

* Fork Repo git@github.com:OfirGan/kandula-project-app.git
* Edit jenkinsfile.groovy
    * docker_repository = "your dockerhub repo"
    * github_repo_ssh_Path = "git ssh path to this forked repo"

~~~

# Manually Config Jenkis To Deploy App:

~~~

## Create Users: (hard coded ids in https://github.com/OfirGan/kandula-project-app/blob/final-project/jenkinsfile.groovy)
* dockerhub.user (user & pass) - To Push Image to Dockerhub Repo
* github.user (ssh + key) - To Clone Kandula-App Repo
* aws.ubuntu (ssh + key) 

## Add Nodes:
* Name -> Node1..
* Remote root directory -> /home/ubuntu/jenkins_home
* Labels -> docker (hard coded ids in jenkinsfile.groovy)
* Launch method -> SSH (aws.ubuntu)
* Host Key Verification Strategy -> none

## Create Pipeline:
* SCM -> Git
* Repository URL -> git ssh path to this forked repo
* Credentials -> github
* Branch -> final-project
* Script Path -> jenkinsfile.groovy

* run pipeline 2 times (first will fail due to params config)
~~~