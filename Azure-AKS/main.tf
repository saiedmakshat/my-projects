# # Creating resource groups for each VNET
# resource "azurerm_resource_group" "rg-spoke" {
#   for_each = var.vnets

#   name     = "rg-${each.value.name}-${var.product_name}"
#   location = var.location
#   tags = {
#     source      = "terraform"
#   }
# }

#Creating resource groups for each VNET
resource "azurerm_resource_group" "rg-hub" {
  #for_each = var.vnets

  name     = "rg-hub-${var.product_name}"
  location = var.location
  tags = var.tags-for-all
}
resource "azurerm_resource_group" "rg-spoke-prod" {
  #for_each = var.vnets

  name     = "rg-spoke-${var.product_name}-prod"
  location = var.location
  tags = var.tags-for-all
}
