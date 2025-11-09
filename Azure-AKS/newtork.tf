# Creating the HUB VNET
resource "azurerm_virtual_network" "vnet-hub" {
  name                = "vnet-hub-${var.product_name}"
  address_space       = ["${local.vnets_address.hub-address.address_prefix}"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-hub.name
  tags                = var.tags-for-all
  depends_on          = [azurerm_resource_group.rg-hub]
}
# Creating the Subnets in HUB VNET
resource "azurerm_subnet" "hub-subnets" {
  for_each             = local.subnets_hub
  name                 = "subnet-${each.key}"
  address_prefixes     = ["${each.value.address_prefix}"]
  resource_group_name  = azurerm_virtual_network.vnet-hub.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-hub.name
  depends_on           = [azurerm_virtual_network.vnet-hub]
}

# Creating the Production SPOKE VNET
resource "azurerm_virtual_network" "vnet-spoke-prod" {
  name                = "vnet-spoke-${var.product_name}-prod"
  address_space       = ["${local.vnets_address.prod-address.address_prefix}"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg-spoke-prod.name
  tags                = var.tags-for-all
  depends_on          = [azurerm_resource_group.rg-spoke-prod]
}
# Creating the Subnets in Production SPOKE VNET
resource "azurerm_subnet" "spoke-subnets-prod" {
  for_each             = local.subnets_prod
  name                 = "subnet-${each.key}"
  address_prefixes     = ["${each.value.address_prefix}"]
  resource_group_name  = azurerm_virtual_network.vnet-spoke-prod.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet-spoke-prod.name
  depends_on           = [azurerm_virtual_network.vnet-spoke-prod]
}
