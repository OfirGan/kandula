output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets_ids" {
  value = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets_ids
}

output "cluster_name" {
  description = "Kubernetes Cluster name"
  value       = module.vpc.cluster_name
}
