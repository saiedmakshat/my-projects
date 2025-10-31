terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.5.0"
    }
  }

    backend "azurerm" {
    resource_group_name = "your-resource-group"  # Replace with your resource group name
    storage_account_name = "your-storage-account"  # Replace with your storage account name
    container_name = "terraform-state"  # Replace with your desired container name
    key = "terraform.tfstate"  # Optional: Specify the filename within the container (defaults to 'terraform.tfstate')
  }
}