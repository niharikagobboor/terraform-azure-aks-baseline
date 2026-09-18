variable "resource_group_name" {
  description = "Name of the parent resource group."
  type        = string
}

variable "location" {
  description = "Azure region where the AKS cluster will be deployed."
  type        = string
}

variable "cluster_name" {
  description = "Name of the managed AKS cluster."
  type        = string
  default     = "aks-baseline-cluster"
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed AKS cluster."
  type        = string
  default     = "aks-baseline"
}

variable "kubernetes_version" {
  description = "Kubernetes version specified for the AKS cluster control plane and nodes."
  type        = string
  default     = "1.30"
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Options: Free, Standard, Premium."
  type        = string
  default     = "Standard"
}

variable "vnet_subnet_id" {
  description = "Resource ID of the existing Virtual Network subnet to attach AKS node pools."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics Workspace for Container Insights and Diagnostic logging."
  type        = string
  default     = null
}

variable "api_server_authorized_ip_ranges" {
  description = "The IP ranges to allow for accessing the Kubernetes API server endpoint."
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "default_node_pool_name" {
  description = "Name of the default system node pool."
  type        = string
  default     = "system"
}

variable "default_node_pool_vm_size" {
  description = "The SKU which should be used for the default node pool Virtual Machines."
  type        = string
  default     = "Standard_D4s_v5"
}

variable "default_node_pool_os_sku" {
  description = "Specifies the OS SKU used by the agent pool. Options: AzureLinux, Ubuntu, Windows2019, Windows2022."
  type        = string
  default     = "AzureLinux"
}

variable "default_node_pool_os_disk_size_gb" {
  description = "The OS Disk Size in GB to be used for each agent in the default node pool."
  type        = number
  default     = 128
}

variable "default_node_pool_node_count" {
  description = "Initial number of nodes in the default node pool."
  type        = number
  default     = 3
}

variable "default_node_pool_min_count" {
  description = "Minimum number of nodes for the default node pool autoscaler."
  type        = number
  default     = 3
}

variable "default_node_pool_max_count" {
  description = "Maximum number of nodes for the default node pool autoscaler."
  type        = number
  default     = 6
}

variable "default_node_pool_critical_addons_only" {
  description = "Enabling this will taint default node pool nodes with CriticalAddonsOnly=true:NoSchedule."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Specifies the availability zones for AKS node pools (e.g., ['1', '2', '3'])."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "key_vault_secret_rotation_enabled" {
  description = "Whether secret rotation is enabled for the Azure Key Vault Secrets Provider addon."
  type        = bool
  default     = true
}

variable "key_vault_secret_rotation_interval" {
  description = "Interval for secret rotation polling by the Key Vault Secrets Provider addon."
  type        = string
  default     = "2m"
}

variable "network_service_cidr" {
  description = "Network range used by Kubernetes services inside the cluster."
  type        = string
  default     = "172.16.0.0/16"
}

variable "network_dns_service_ip" {
  description = "IP address within the Kubernetes service address range used by cluster DNS resolver."
  type        = string
  default     = "172.16.0.10"
}

variable "enable_user_node_pool" {
  description = "Whether to provision an additional dedicated User workload node pool."
  type        = bool
  default     = false
}

variable "user_node_pool_name" {
  description = "Name of the dedicated user node pool."
  type        = string
  default     = "workload"
}

variable "user_node_pool_vm_size" {
  description = "Virtual Machine SKU for the dedicated user node pool."
  type        = string
  default     = "Standard_D4s_v5"
}

variable "user_node_pool_min_count" {
  description = "Minimum node count for the user node pool autoscaler."
  type        = number
  default     = 1
}

variable "user_node_pool_max_count" {
  description = "Maximum node count for the user node pool autoscaler."
  type        = number
  default     = 5
}

variable "tags" {
  description = "A mapping of tags to assign to the AKS resources."
  type        = map(string)
  default     = {}
}
