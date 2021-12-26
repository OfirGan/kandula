
###################################################################################
# OUTPUT
###################################################################################

output "bastion_server_public_ip" {
  description = "Bastion host Public IP"
  value       = module.servers.bastion_server_public_ip
}

output "bastion_server_private_ip" {
  description = "Bastion host Private IP"
  value       = module.servers.bastion_server_private_ip
}

output "consul_servers_private_ips" {
  description = "Consul Servers Private IP's"
  value       = module.servers.jenkins_server_private_ip
}

output "jenkins_server_private_ip" {
  description = "Jenkins server Private IP"
  value       = module.servers.jenkins_server_private_ip
}

output "jenkins_nodes_private_ip" {
  description = "Private IP's of the Jenkins nodes"
  value       = module.servers.jenkins_nodes_private_ip
}

output "ansible_server_private_ip" {
  description = "Ansible Server Private IP"
  value       = module.servers.ansible_server_private_ip
}

output "consul_alb_public_dns" {
  description = "Consul ALB Public DNS name"
  value       = module.servers.consul_alb_public_dns
}

output "jenkins_alb_public_dns" {
  description = "Jenkins ALB Public DNS name"
  value       = module.servers.jenkins_alb_public_dns
}
