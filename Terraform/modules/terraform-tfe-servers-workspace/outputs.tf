###################################################################################
# OUTPUT
###################################################################################

output "workspace_id" {
  description = "Servers Workspace ID"
  value       = resource.tfe_workspace.servers_workspace.id
}
