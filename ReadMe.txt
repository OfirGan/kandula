
prerequisits:
=============
aws cli
kubectl


To Do:
=======

python3 /c/Downloads/OpsSchool/Assignments/Kandula/kandula/Python/Deploy.py


Terraform Cloud:
* apply vpc
* apply servers
* apply kubernetes


================
    Jenkis:
================
Create Users:
-------------
dockerhub.ofirgan (user & pass) - keypass
github.ofirgan (ssh + key) - C:\Downloads\OpsSchool\Private-Keys
aws.ubuntu (ssh + key) - C:\Downloads\OpsSchool\Private-Keys

Create Secret Text:
-------------------
aws.access_key -> from terraform.tfvars
aws.secret_key -> from terraform.tfvars
aws.region -> from terraform.tfvars

Add Nodes:
----------
Name -> Node1
Remote root directory -> /home/ubuntu/jenkins_home
Labels -> docker
Launch method -> SSH (aws.ubuntu)
Host Key Verification Strategy -> none

Create Pipeline:
----------------
SCM -> Git
Repository URL -> git@github.com:OfirGan/kandula.git
Credentials -> github
Branch -> mid-project
Script Path -> Jenkins/Jenkinsfile.groovy
