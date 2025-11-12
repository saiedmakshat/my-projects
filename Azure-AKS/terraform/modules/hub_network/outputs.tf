# terraform/modules/hub_network/outputs.tf
output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub_vnet.name
}

output "hub_fw_private_ip" {
  value = azurerm_firewall.azure_firewall.ip_configuration.0.private_ip_address
  #value = azurerm_firewall_policy.firewall-policy.private_ip_ranges
}

output "hub_rg_name" {
  value = azurerm_resource_group.rg_hub_networks.name
}

output "hub_pip" {
  value = azurerm_public_ip.hub_pip.ip_address
}