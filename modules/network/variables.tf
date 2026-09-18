variable "resource_group_name" {
  description = "Name of the parent resource group."
  type        = string
}

variable "location" {
  description = "Azure region where the network resources will be provisioned."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
  default     = "vnet-aks-baseline"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network."
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "aks_subnet_name" {
  description = "Name of the dedicated AKS nodes subnet."
  type        = string
  default     = "snet-aks-nodes"
}

variable "aks_subnet_address_prefixes" {
  description = "Address prefix CIDR blocks for the AKS subnet."
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "tags" {
  description = "A mapping of tags to assign to the network resources."
  type        = map(string)
  default     = {}
}
