output "resource_group_name" {
  description = "The name of the provisioned Azure Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "The resource ID of the provisioned Azure Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "vnet_id" {
  description = "The resource ID of the Virtual Network."
  value       = module.network.vnet_id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = module.network.vnet_name
}

output "aks_subnet_id" {
  description = "The resource ID of the dedicated AKS subnet."
  value       = module.network.aks_subnet_id
}

output "network_security_group_id" {
  description = "The resource ID of the AKS Network Security Group."
  value       = module.network.network_security_group_id
}

output "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.law.name
}

output "aks_cluster_id" {
  description = "The resource ID of the AKS cluster."
  value       = module.aks.cluster_id
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster."
  value       = module.aks.cluster_name
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster control plane."
  value       = module.aks.cluster_fqdn
}

output "aks_oidc_issuer_url" {
  description = "The OIDC issuer URL for Azure Workload Identity federation."
  value       = module.aks.oidc_issuer_url
}

output "aks_cluster_identity_principal_id" {
  description = "The Principal ID of the AKS cluster SystemAssigned Managed Identity."
  value       = module.aks.cluster_identity_principal_id
}

output "aks_node_resource_group" {
  description = "The name of the managed resource group containing AKS node pools and infrastructure."
  value       = module.aks.node_resource_group
}

output "aks_key_vault_secrets_provider_client_id" {
  description = "The Client ID of the User Assigned Identity created by the Key Vault Secrets Provider addon."
  value       = module.aks.key_vault_secrets_provider_client_id
}

output "aks_key_vault_secrets_provider_object_id" {
  description = "The Object ID of the User Assigned Identity created by the Key Vault Secrets Provider addon."
  value       = module.aks.key_vault_secrets_provider_object_id
}

output "kube_config_raw" {
  description = "Raw Kubernetes configuration to authenticate against the cluster."
  value       = module.aks.kube_config_raw
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw Kubernetes admin configuration to authenticate against the cluster."
  value       = module.aks.kube_admin_config_raw
  sensitive   = true
}
