# modules/spoke/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}
variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
}
variable "spoke_address_space" {
  description = "Address space for the spoke virtual network"
  type        = list(string)
}
variable "privatelink_subnet_prefix" {
  type = list(string)
}
variable "ingress_subnet_prefix" {
  type = list(string)
}
variable "applicationgateway_subnet_prefix" {
  type = list(string)
}
variable "clusternodes_subnet_prefix" {
  type = list(string)
}
variable "hub_vnet_id" {
  description = "ID of the hub virtual network"
  type        = string
}
variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}
variable "firewall_private_ip" {
  description = "Private IP of the Azure Firewall"
  type        = string
}
variable "remote_spoke_address_space" {
  description = "Address space of the remote spoke network"
  type        = list(string)
}
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}