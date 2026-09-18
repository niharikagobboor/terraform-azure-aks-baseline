variable "resource_group_name" {
  description = "Name of the Azure Resource Group."
  type        = string
  default     = "rg-aks-baseline"
}

variable "location" {
  description = "Azure region where all resources will be deployed."
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
  default     = "vnet-aks-baseline"
}

variable "vnet_address_space" {
  description = "Address space CIDR blocks for the Virtual Network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the dedicated AKS node subnet."
  type        = string
  default     = "snet-aks-nodes"
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefix CIDR blocks for the AKS subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics Workspace for Container Insights and diagnostic logs."
  type        = string
  default     = "law-aks-baseline"
}

variable "log_analytics_workspace_sku" {
  description = "Pricing SKU for the Log Analytics Workspace."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_retention_in_days" {
  description = "Log data retention period in days."
  type        = number
  default     = 30
}

variable "cluster_name" {
  description = "Name of the AKS cluster."
  type        = string
  default     = "aks-baseline-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the AKS cluster."
  type        = string
  default     = "aks-baseline"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster control plane and nodes."
  type        = string
  default     = "1.30"
}

variable "sku_tier" {
  description = "Pricing tier for AKS cluster SLA. Options: Free, Standard, Premium."
  type        = string
  default     = "Standard"
}

variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP CIDR ranges permitted to access the Kubernetes API Server."
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "default_node_pool_name" {
  description = "Name of the system node pool."
  type        = string
  default     = "system"
}

variable "default_node_pool_vm_size" {
  description = "Azure VM SKU for the system node pool."
  type        = string
  default     = "Standard_D4s_v5"
}

variable "default_node_pool_os_sku" {
  description = "Operating system SKU for nodes. Options: AzureLinux, Ubuntu."
  type        = string
  default     = "AzureLinux"
}

variable "default_node_pool_os_disk_size_gb" {
  description = "OS disk size in GB for system nodes."
  type        = number
  default     = 128
}

variable "default_node_pool_node_count" {
  description = "Initial node count for the default system node pool."
  type        = number
  default     = 3
}

variable "default_node_pool_min_count" {
  description = "Minimum node count for system node pool autoscaling."
  type        = number
  default     = 3
}

variable "default_node_pool_max_count" {
  description = "Maximum node count for system node pool autoscaling."
  type        = number
  default     = 6
}

variable "default_node_pool_critical_addons_only" {
  description = "Whether to taint default node pool with CriticalAddonsOnly=true:NoSchedule."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of availability zones to distribute nodes across."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "key_vault_secret_rotation_enabled" {
  description = "Enable periodic secret rotation for Key Vault Secrets Provider addon."
  type        = bool
  default     = true
}

variable "key_vault_secret_rotation_interval" {
  description = "Polling interval for secret rotation (e.g., '2m')."
  type        = string
  default     = "2m"
}

variable "network_service_cidr" {
  description = "Kubernetes internal service CIDR block."
  type        = string
  default     = "172.16.0.0/16"
}

variable "network_dns_service_ip" {
  description = "Kubernetes internal CoreDNS service IP address."
  type        = string
  default     = "172.16.0.10"
}

variable "enable_user_node_pool" {
  description = "Whether to provision an additional dedicated user workload node pool."
  type        = bool
  default     = false
}

variable "user_node_pool_name" {
  description = "Name of the user workload node pool."
  type        = string
  default     = "workload"
}

variable "user_node_pool_vm_size" {
  description = "VM SKU for the user workload node pool."
  type        = string
  default     = "Standard_D4s_v5"
}

variable "user_node_pool_min_count" {
  description = "Minimum node count for user node pool autoscaler."
  type        = number
  default     = 1
}

variable "user_node_pool_max_count" {
  description = "Maximum node count for user node pool autoscaler."
  type        = number
  default     = 5
}

variable "tags" {
  description = "Standard resource tags applied to all Azure resources."
  type        = map(string)
  default = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    Project     = "aks-baseline"
  }
}
