# terraform/modules/cluster/variables.tf
variable "resource_group_location" {
  description = "The location of the resource group"
}

variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "resource_group_id" {
  description = "The id of the resource group"
}

variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "vnet_subnet_id" {
  description = "The id of the subnet"
}

variable "application_gateway_id" {
  description = "The id of the application gateway"
}

variable "vm_size" {
  type        = string
  description = "The size of the Virtual Machine."
  default     = "standard_dc2ads_v5" #Standard_B2s_v2 , standard_d2ds_v4
}

variable "spoke_pip_id" {
  description = "The id of the spoke public IP"
}

variable "keyvault_name" {
  type    = string
  default = "KeyVaultTestingNawras"
}
variable "tenant_id" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "azurerm_kubernetes_cluster_name" {
  type    = string
  default = "Cluster-Nawras"
}