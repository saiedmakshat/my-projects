variable "subscription_id" {}
variable "tenant_id" {}
variable "object_id" {}
variable "client_id" {}
variable "client_secret" { sensitive = true }

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "RG-Nawras"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "service_principal_name" {
  type    = string
  default = "service_principal-nawras"
}

variable "keyvault_name" {
  type    = string
  default = "key-vault-nawras"
}