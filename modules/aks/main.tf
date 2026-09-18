resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.cluster_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  sku_tier                          = var.sku_tier
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  azure_policy_enabled              = true
  role_based_access_control_enabled = true

  api_server_access_profile {
    authorized_ip_ranges = var.api_server_authorized_ip_ranges
  }

  default_node_pool {
    name                         = var.default_node_pool_name
    vm_size                      = var.default_node_pool_vm_size
    vnet_subnet_id               = var.vnet_subnet_id
    os_disk_size_gb              = var.default_node_pool_os_disk_size_gb
    os_disk_type                 = "Managed"
    os_sku                       = var.default_node_pool_os_sku
    type                         = "VirtualMachineScaleSets"
    zones                        = var.availability_zones
    enable_auto_scaling          = true
    min_count                    = var.default_node_pool_min_count
    max_count                    = var.default_node_pool_max_count
    node_count                   = var.default_node_pool_node_count
    only_critical_addons_enabled = var.default_node_pool_critical_addons_only
    enable_node_public_ip        = false

    tags = merge(var.tags, {
      "NodePool" = "system"
    })
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = var.key_vault_secret_rotation_enabled
    secret_rotation_interval = var.key_vault_secret_rotation_interval
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id      = var.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = true
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = var.network_service_cidr
    dns_service_ip    = var.network_dns_service_ip
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  count                 = var.enable_user_node_pool ? 1 : 0
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_pool_vm_size
  vnet_subnet_id        = var.vnet_subnet_id
  os_disk_size_gb       = 128
  os_disk_type          = "Managed"
  os_sku                = "AzureLinux"
  zones                 = var.availability_zones
  mode                  = "User"
  enable_auto_scaling   = true
  min_count             = var.user_node_pool_min_count
  max_count             = var.user_node_pool_max_count
  enable_node_public_ip = false

  tags = merge(var.tags, {
    "NodePool" = "user"
  })

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

resource "azurerm_role_assignment" "aks_subnet_network_contributor" {
  scope                = var.vnet_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.cluster_name}-diagnostic"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
