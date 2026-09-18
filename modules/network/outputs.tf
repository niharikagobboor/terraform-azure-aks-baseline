output "vnet_id" {
  description = "The ID of the provisioned Virtual Network."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the provisioned Virtual Network."
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "The address space list of the provisioned Virtual Network."
  value       = azurerm_virtual_network.vnet.address_space
}

output "aks_subnet_id" {
  description = "The ID of the provisioned AKS subnet."
  value       = azurerm_subnet.aks.id
}

output "aks_subnet_name" {
  description = "The name of the provisioned AKS subnet."
  value       = azurerm_subnet.aks.name
}

output "aks_subnet_address_prefixes" {
  description = "The address prefix list of the AKS subnet."
  value       = azurerm_subnet.aks.address_prefixes
}

output "network_security_group_id" {
  description = "The ID of the AKS Network Security Group."
  value       = azurerm_network_security_group.aks_nsg.id
}

output "network_security_group_name" {
  description = "The name of the AKS Network Security Group."
  value       = azurerm_network_security_group.aks_nsg.name
}
