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
variable "resource_group_location" {
  description = "The location of the resource group"
  default     = "eastus"
}

variable "application_id" {
  description = "The application id"
  default     = "Nawras-Microservices"
}

variable "cluster_nodes_address_space" {
  description = "The address space for the cluster nodes."
  default     = "10.240.0.0/22"
}

# variable "host_name" {
#   description = "The host name"
#   default     = "store.example.com"
# }


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
variable "acr_name" {
  type    = string
  default = "NawrasACR"
}