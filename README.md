# terraform-azure-aks-baseline

Terraform configuration for provisioning an Azure Kubernetes Service (AKS) cluster with Azure CNI, Container Insights, Workload Identity, and Key Vault Secrets Provider.

## Architecture

```
                               +-----------------------------+
                               |   Log Analytics Workspace   |
                               |   - Container Insights      |
                               |   - Control Plane Logs      |
                               +--------------^--------------+
                                              |
+---------------------------------------------|--------------------------+
| Resource Group: rg-aks-baseline             |                          |
|                                             |                          |
|   +-----------------------------------------+----------------------+   |
|   | Virtual Network: 10.10.0.0/16                                  |   |
|   |                                                                |   |
|   |   +--------------------------------------------------------+   |   |
|   |   | Subnet: snet-aks-nodes (10.10.1.0/24)                  |   |   |
|   |   | Associated NSG: vnet-aks-baseline-aks-nsg              |   |   |
|   |   |                                                        |   |   |
|   |   |   +------------------------------------------------+   |   |   |
|   |   |   | AKS Cluster: aks-baseline-cluster              |   |   |   |
|   |   |   | - System Pool (Autoscaling 3..6, Multi-AZ)     |   |   |   |
|   |   |   | - Azure CNI + Azure Network Policy             |   |   |   |
|   |   |   | - OIDC Issuer & Workload Identity              |   |   |   |
|   |   |   | - Key Vault Secrets Provider Addon             |   |   |   |
|   |   |   | - Azure Policy Addon                           |   |   |   |
|   |   |   | - API Server Authorized IP Ranges              |   |   |   |
|   |   |   +------------------------------------------------+   |   |   |
|   |   +--------------------------------------------------------+   |   |
|   +----------------------------------------------------------------+   |
+------------------------------------------------------------------------+
```

### Directory Structure

```
terraform-azure-aks-baseline/
├── .gitignore
├── azure-pipelines.yml
├── main.tf
├── outputs.tf
├── README.md
├── terraform.tfvars.example
├── variables.tf
├── versions.tf
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── variables.tf
    └── aks/
        ├── main.tf
        ├── outputs.tf
        └── variables.tf
```

## Prerequisites

- Terraform `>= 1.5.0`
- Azure CLI `>= 2.50.0`
- Target Azure subscription with `Contributor` and `User Access Administrator` (or `Owner`) roles
- `kubectl` `>= 1.28.0`
- Trivy `>= 0.50.0` (optional, for local IaC validation)

## Usage

### 1. Authenticate

```bash
az login
az account set --subscription "<SUBSCRIPTION_ID>"
```

### 2. Initialize and Validate

```bash
terraform init
terraform fmt -check -recursive
terraform validate
trivy config . --exit-code 1 --severity HIGH,CRITICAL
```

### 3. Plan and Apply

```bash
terraform plan -var-file="terraform.tfvars.example" -out="tfplan"
terraform apply "tfplan"
```

### 4. Connect to Cluster

```bash
az aks get-credentials \
  --resource-group "$(terraform output -raw resource_group_name)" \
  --name "$(terraform output -raw aks_cluster_name)"

kubectl get nodes -o wide
```

### 5. Destroy

```bash
terraform destroy -var-file="terraform.tfvars.example" -auto-approve
```

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :--- |
| `resource_group_name` | Name of the Azure Resource Group | `string` | `"rg-aks-baseline"` | no |
| `location` | Azure region for resources | `string` | `"eastus"` | no |
| `vnet_name` | Name of the Virtual Network | `string` | `"vnet-aks-baseline"` | no |
| `vnet_address_space` | CIDR blocks for the Virtual Network | `list(string)` | `["10.10.0.0/16"]` | no |
| `aks_subnet_name` | Name of the AKS node subnet | `string` | `"snet-aks-nodes"` | no |
| `aks_subnet_address_prefixes` | CIDR prefix for the AKS subnet | `list(string)` | `["10.10.1.0/24"]` | no |
| `log_analytics_workspace_name` | Name of the Log Analytics Workspace | `string` | `"law-aks-baseline"` | no |
| `log_analytics_workspace_sku` | SKU for the Log Analytics Workspace | `string` | `"PerGB2018"` | no |
| `log_analytics_retention_in_days` | Retention period in days | `number` | `30` | no |
| `cluster_name` | Name of the AKS cluster | `string` | `"aks-baseline-cluster"` | no |
| `dns_prefix` | DNS prefix for the cluster | `string` | `"aks-baseline"` | no |
| `kubernetes_version` | Kubernetes version | `string` | `"1.30"` | no |
| `sku_tier` | SLA tier (`Free`, `Standard`, `Premium`) | `string` | `"Standard"` | no |
| `api_server_authorized_ip_ranges` | CIDR ranges authorized to reach the API server | `list(string)` | `["203.0.113.0/24"]` | no |
| `default_node_pool_name` | System node pool name | `string` | `"system"` | no |
| `default_node_pool_vm_size` | VM size for system nodes | `string` | `"Standard_D4s_v5"` | no |
| `default_node_pool_os_sku` | Node OS SKU (`AzureLinux`, `Ubuntu`) | `string` | `"AzureLinux"` | no |
| `default_node_pool_os_disk_size_gb` | OS disk size in GB | `number` | `128` | no |
| `default_node_pool_node_count` | Initial node count | `number` | `3` | no |
| `default_node_pool_min_count` | Minimum autoscaler node count | `number` | `3` | no |
| `default_node_pool_max_count` | Maximum autoscaler node count | `number` | `6` | no |
| `default_node_pool_critical_addons_only` | Taint system nodes with `CriticalAddonsOnly` | `bool` | `false` | no |
| `availability_zones` | Availability zones | `list(string)` | `["1", "2", "3"]` | no |
| `key_vault_secret_rotation_enabled` | Enable Key Vault secret rotation | `bool` | `true` | no |
| `key_vault_secret_rotation_interval` | Polling interval for secret rotation | `string` | `"2m"` | no |
| `network_service_cidr` | Kubernetes internal service CIDR | `string` | `"172.16.0.0/16"` | no |
| `network_dns_service_ip` | CoreDNS service IP | `string` | `"172.16.0.10"` | no |
| `enable_user_node_pool` | Provision a dedicated user node pool | `bool` | `false` | no |
| `user_node_pool_name` | User node pool name | `string` | `"workload"` | no |
| `user_node_pool_vm_size` | VM size for user nodes | `string` | `"Standard_D4s_v5"` | no |
| `user_node_pool_min_count` | Minimum user node count | `number` | `1` | no |
| `user_node_pool_max_count` | Maximum user node count | `number` | `5` | no |
| `tags` | Resource tags | `map(string)` | `{ Environment = "Production", ... }` | no |

## Outputs

| Name | Description | Sensitive |
| :--- | :--- | :--- |
| `resource_group_name` | Provisioned Resource Group name | `false` |
| `resource_group_id` | Resource Group ID | `false` |
| `vnet_id` | Virtual Network ID | `false` |
| `vnet_name` | Virtual Network name | `false` |
| `aks_subnet_id` | Dedicated AKS subnet ID | `false` |
| `network_security_group_id` | AKS Network Security Group ID | `false` |
| `log_analytics_workspace_id` | Log Analytics Workspace ID | `false` |
| `log_analytics_workspace_name` | Log Analytics Workspace name | `false` |
| `aks_cluster_id` | AKS cluster ID | `false` |
| `aks_cluster_name` | AKS cluster name | `false` |
| `aks_cluster_fqdn` | AKS cluster control plane FQDN | `false` |
| `aks_oidc_issuer_url` | OIDC issuer URL for Workload Identity federation | `false` |
| `aks_cluster_identity_principal_id` | Principal ID of AKS SystemAssigned Managed Identity | `false` |
| `aks_node_resource_group` | Managed resource group containing nodes and load balancers | `false` |
| `aks_key_vault_secrets_provider_client_id` | Client ID of Key Vault addon identity | `false` |
| `aks_key_vault_secrets_provider_object_id` | Object ID of Key Vault addon identity | `false` |
| `kube_config_raw` | Kubernetes client config | `true` |
| `kube_admin_config_raw` | Kubernetes admin client config | `true` |
