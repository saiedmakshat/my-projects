resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tag-test
}
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-resource-group
  location = local.hub-location
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = local.spoke1-resource-group
  location = local.spoke1-location
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = local.spoke2-location
}

resource "azurerm_resource_group" "hub-nva-rg" {
  name     = "${local.prefix-hub-nva}-rg-${random_string.suffix.result}"
  location = local.hub-nva-location

  tags = {
    environment = local.prefix-hub-nva
  }
}