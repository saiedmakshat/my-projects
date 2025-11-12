variable "prefix" {
  type    = string
  default = "225"
}

variable "subscription_id" {}
variable "tenant_id" {}
variable "object_id" {}
variable "client_id" {}
variable "client_secret" { sensitive = true }