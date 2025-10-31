terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate-nawras"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }


}

provider "azurerm" {
  features {}
}