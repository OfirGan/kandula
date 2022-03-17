
###################################################################################
# OUTPUT
###################################################################################

output "rds_endpoint" {
  description = "RDS Connection Endpoint"
  value       = aws_db_instance.postgres_db_instance.endpoint
}

output "rds_address" {
  description = "RDS Host address"
  value       = aws_db_instance.postgres_db_instance.address
}

output "rds_port" {
  description = "RDS Port"
  value       = aws_db_instance.postgres_db_instance.port
}
