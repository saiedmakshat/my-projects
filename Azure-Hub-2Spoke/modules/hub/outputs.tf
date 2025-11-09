# modules/hub/outputs.tf
output "hub_vnet_id" {
  description = "The ID of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.id
}
output "hub_vnet_name" {
  description = "The name of the Hub Virtual Network"
  value       = azurerm_virtual_network.hub.name
}
output "gateway_subnet_id" {
  description = "The ID of the Gateway Subnet"
  value       = azurerm_subnet.gateway.id
}
output "firewall_subnet_id" {
  description = "The ID of the Firewall Subnet"
  value       = azurerm_subnet.firewall.id
}
output "bastion_subnet_id" {
  description = "The ID of the Bastion Subnet"
  value       = azurerm_subnet.bastion.id
}
output "management_subnet_id" {
  description = "The ID of the Management Subnet"
  value       = azurerm_subnet.management.id
}