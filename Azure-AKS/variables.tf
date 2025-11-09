variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "location" {
  type    = string
  default = "eastus"
}

variable "tags-for-all" {
  type = map(string)
  default = {
    source   = "terraform"
    platform = "nawras"
    company  = "obeikan"
  }
}

variable "product_name" {
  type        = string
  nullable    = false
  description = "(Mandatory) Project/Application name. e.g skynet \nThis will be used as prefix for all resources created."
  default     = "Nawras"
}

locals {
  vnets_address = {
    "hub-address" = {
      address_prefix = "10.0.0.0/24"
    },
    "prod-address" = {
      address_prefix = "10.1.0.0/16"
    }
  }
  subnets_hub = {
    "Firewall" = {
      address_prefix = "10.0.0.0/26"
    },
    "Management" = {
      address_prefix = "10.0.0.64/26"
    },
    "Gateway" = {
      address_prefix = "10.0.0.128/27"
    }
  }
  subnets_prod = {
    "PrivateLink" = {
      address_prefix = "10.1.4.32/28"
    },
    "IngressResources" = {
      address_prefix = "10.1.4.0/28"
    },
    "ApplicationGateway" = {
      address_prefix = "10.1.5.128/24"
    },
    "ClusterNode" = {
      address_prefix = "10.1.0.0/22"
    }
  }

}