# modules/spoke/main.tf
# Spoke Virtual Network
resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_vnet_name
  address_space       = var.spoke_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Spoke Subnets
resource "azurerm_subnet" "privatelink" {
  name                 = "snet-PrivateLink"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.privatelink_subnet_prefix
}
resource "azurerm_subnet" "ingress" {
  name                 = "snet-IngressResource"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.ingress_subnet_prefix
}
resource "azurerm_subnet" "applicationgateway" {
  name                 = "snet-ApplicationGateway"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.applicationgateway_subnet_prefix
}
resource "azurerm_subnet" "clusternodes" {
  name                 = "snet-ClusterNodes"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = var.clusternodes_subnet_prefix
}
# VNet Peering: Hub to Spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "peer-${var.hub_vnet_name}-to-${var.spoke_vnet_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}
# VNet Peering: Spoke to Hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "peer-${var.spoke_vnet_name}-to-${var.hub_vnet_name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.hub_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}
# Route Table for Spoke
resource "azurerm_route_table" "spoke" {
  name                = "rt-${var.spoke_vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
# Route to remote Spoke via Firewall
resource "azurerm_route" "to_remote_spoke" {
  name                = "route-to-remote-spoke"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.spoke.name
  address_prefix      = var.remote_spoke_address_space[0]
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}
# Route for Internet Access via Firewall
resource "azurerm_route" "to_internet" {
  name                = "route-to-internet"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.spoke.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}
# Associate Route Table to Spoke Subnets
resource "azurerm_subnet_route_table_association" "workload" {
  subnet_id      = azurerm_subnet.applicationgateway.id
  route_table_id = azurerm_route_table.spoke.id
}

# resource "azurerm_subnet_route_table_association" "management" {
#   subnet_id      = azurerm_subnet.management.id
#   route_table_id = azurerm_route_table.spoke.id
# }