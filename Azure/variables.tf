variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "location" {
    default = "eastus"
    type = string
}

variable "tag-test" {
  type = map(string)
  default = {
    "environment" = "testing"
  }
}

variable "tag-stage" {
  type = map(string)
  default = {
    "environment" = "staging"
  }
}
variable "tag-production" {
  type = map(string)
  default = {
    "environment" = "production"
  }
}


variable "resource_group_name" {
  type        = string
  default = "rg"
}
