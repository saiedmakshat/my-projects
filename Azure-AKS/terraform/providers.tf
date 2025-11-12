# terraform/providers.tf
terraform {
  required_version = ">=1.8"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.52.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "=2.7.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=3.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.7.2"
    }
    time = {
      source  = "hashicorp/time"
      version = "=0.13.1"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

  }
}