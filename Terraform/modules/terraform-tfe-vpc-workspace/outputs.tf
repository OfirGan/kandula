###################################################################################
# OUTPUT
###################################################################################

output "workspace_id" {
  description = "VPC Workspace ID"
  value       = resource.tfe_workspace.vpc_workspace.id
}
