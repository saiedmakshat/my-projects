# terraform/modules/hub_network/variables.tf
variable "resource_group_location" {
  description = "The location of the resource group"
}

variable "hub_vnet_address_space" {
  description = "The address space for the hub virtual network."
  default     = "10.200.0.0/24"
}

variable "azure_firewall_address_space" {
  description = "The address space for the Azure Firewall subnet."
  default     = "10.200.0.0/26"
}
variable "azure_firewall_address_space1" {
  description = "The address space for the Azure Firewall subnet."
  default     = "10.200.0.64/26"
}

variable "cluster_nodes_address_space" {
  description = "The address space for the cluster nodes."
}

variable "azure_firewall_policy_name" {
  default = "fwp-main"
}
