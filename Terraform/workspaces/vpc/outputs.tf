output "vpc_id" {
  value = module.vpc.vpc_id
}

output "route53_zone_zone_id" {
  value = module.vpc.route53_zone_zone_id
}

output "public_subnets_ids" {
  value = module.vpc.public_subnets_ids
}

output "private_subnets_ids" {
  value = module.vpc.private_subnets_ids
}

output "ec2_describe_instances_role_arn" {
  description = "EC2 Describe Instances Role ARN"
  value       = module.vpc.ec2_describe_instances_role_arn
}

output "ec2_describe_instances_instance_profile_id" {
  description = "EC2 Describe Instances Instance Profile ID"
  value       = module.vpc.ec2_describe_instances_instance_profile_id
}

output "aws_iam_server_certificate_arn" {
  description = "AWS IAM Server Certificate ARN"
  value       = module.vpc.aws_iam_server_certificate_arn
}
