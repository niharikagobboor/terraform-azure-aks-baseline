output "cluster_id" {
  description = "The ID of the provisioned AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "The name of the provisioned AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "cluster_fqdn" {
  description = "The FQDN of the Azure Kubernetes Managed Cluster."
  value       = azurerm_kubernetes_cluster.aks.fqdn
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL for Azure Workload Identity federation."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "cluster_identity_principal_id" {
  description = "The Principal ID of the SystemAssigned Managed Identity of the cluster."
  value       = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

output "cluster_identity_tenant_id" {
  description = "The Tenant ID of the SystemAssigned Managed Identity of the cluster."
  value       = azurerm_kubernetes_cluster.aks.identity[0].tenant_id
}

output "node_resource_group" {
  description = "The auto-generated Resource Group containing AKS cluster agent nodes and load balancers."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "key_vault_secrets_provider_client_id" {
  description = "The Client ID of the User Assigned Identity created by the Key Vault Secrets Provider addon."
  value       = try(azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].client_id, null)
}

output "key_vault_secrets_provider_object_id" {
  description = "The Object ID of the User Assigned Identity created by the Key Vault Secrets Provider addon."
  value       = try(azurerm_kubernetes_cluster.aks.key_vault_secrets_provider[0].secret_identity[0].object_id, null)
}

output "kube_config_raw" {
  description = "Raw Kubernetes configuration to authenticate against the cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "kube_admin_config_raw" {
  description = "Raw Kubernetes admin configuration to authenticate against the cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive   = true
}
