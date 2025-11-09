# modules/spoke/outputs.tf
output "spoke_vnet_id" {
  description = "The ID of the Spoke Virtual Network"
  value       = azurerm_virtual_network.spoke.id
}
output "spoke_address_space" {
  description = "The address space of the Spoke Virtual Network"
  value       = var.spoke_address_space
}
output "privatelink_subnet_id" {
  value       = azurerm_subnet.privatelink.id
}
output "ingress_subnet_id" {
  value       = azurerm_subnet.ingress.id
}
output "applicationgateway_subnet_id" {
  value       = azurerm_subnet.applicationgateway.id
}
output "clusternodes_subnet_id" {
  value       = azurerm_subnet.clusternodes.id
}
output "route_table_id" {
  description = "The ID of the Route Table"
  value       = azurerm_route_table.spoke.id
}