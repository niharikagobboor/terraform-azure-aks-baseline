resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_retention_in_days
  tags                = var.tags
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.law.id
  workspace_name        = azurerm_log_analytics_workspace.law.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

module "network" {
  source = "./modules/network"

  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  vnet_name                   = var.vnet_name
  vnet_address_space          = var.vnet_address_space
  aks_subnet_name             = var.aks_subnet_name
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes
  tags                        = var.tags
}

module "aks" {
  source = "./modules/aks"

  resource_group_name                    = azurerm_resource_group.rg.name
  location                               = azurerm_resource_group.rg.location
  cluster_name                           = var.cluster_name
  dns_prefix                             = var.dns_prefix
  kubernetes_version                     = var.kubernetes_version
  sku_tier                               = var.sku_tier
  vnet_subnet_id                         = module.network.aks_subnet_id
  log_analytics_workspace_id             = azurerm_log_analytics_workspace.law.id
  api_server_authorized_ip_ranges        = var.api_server_authorized_ip_ranges
  default_node_pool_name                 = var.default_node_pool_name
  default_node_pool_vm_size              = var.default_node_pool_vm_size
  default_node_pool_os_sku               = var.default_node_pool_os_sku
  default_node_pool_os_disk_size_gb      = var.default_node_pool_os_disk_size_gb
  default_node_pool_node_count           = var.default_node_pool_node_count
  default_node_pool_min_count            = var.default_node_pool_min_count
  default_node_pool_max_count            = var.default_node_pool_max_count
  default_node_pool_critical_addons_only = var.default_node_pool_critical_addons_only
  availability_zones                     = var.availability_zones
  key_vault_secret_rotation_enabled      = var.key_vault_secret_rotation_enabled
  key_vault_secret_rotation_interval     = var.key_vault_secret_rotation_interval
  network_service_cidr                   = var.network_service_cidr
  network_dns_service_ip                 = var.network_dns_service_ip
  enable_user_node_pool                  = var.enable_user_node_pool
  user_node_pool_name                    = var.user_node_pool_name
  user_node_pool_vm_size                 = var.user_node_pool_vm_size
  user_node_pool_min_count               = var.user_node_pool_min_count
  user_node_pool_max_count               = var.user_node_pool_max_count
  tags                                   = var.tags

  depends_on = [
    azurerm_log_analytics_solution.container_insights
  ]
}
