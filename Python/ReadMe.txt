
prerequisits:
=============
aws cli
kubectl


To Do:
=======

cd /c/Downloads/OpsSchool/Assignments/Kandula/kandula/Terraform
terraform plan -out plan.tfstate
terraform apply plan.tfstate

Terraform Cloud:
* apply vpc
* apply servers
* apply kubernetes

python3 /c/Downloads/OpsSchool/Assignments/Kandula/kandula/Python/Deploy.py

Jenkis:
create users:
dockerhub.ofirgan (user & pass) - keypass
github.ofirgan (ssh + key) - C:\Downloads\OpsSchool\Private-Keys
aws.ubuntu (ssh + key) - C:\Downloads\OpsSchool\Private-Keys

Add Nodes:
Name -> Node1
Remote root directory -> /home/ubuntu/jenkins_home
Labels -> docker
Launch method -> SSH (aws.ubuntu)
Host Key Verification Strategy -> none

Pipeline:
SCM -> Git
Repository URL -> git@github.com:OfirGan/kandula.git
Credentials -> github
Branch -> mid-project
Script Path -> Jenkins/Jenkinsfile.groovy



aws eks --region=us-east-1 update-kubeconfig --name kandula_k8s_cluster
kubectl get nodes