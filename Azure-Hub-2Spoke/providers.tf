terraform {
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

  #   backend "azurerm" {
  #     resource_group_name  = "Terraform"
  #     storage_account_name = "terraformsaied"
  #     container_name       = "tfstate"
  #     key                  = "terraform.tfstate"
  #   }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}
provider "azuread" {
  # Configuration options
}
provider "azapi" {
  # Configuration options
}
provider "random" {
  # Configuration options
}
provider "time" {
  # Configuration options
}