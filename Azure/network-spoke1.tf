resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "${local.prefix-spoke1}-vnet"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  address_space       = ["${local.spoke1-address}"]

  tags = {
    environment = local.prefix-spoke1
  }
}

resource "azurerm_subnet" "spoke1-mgmt" {
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["${local.spoke1-mgmt-address}"]
}

resource "azurerm_subnet" "spoke1-workload" {
  name                 = "workload"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["${local.spoke1-workload-address}"]
}

resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
  name                      = "${local.prefix-spoke1}-hub-peer"
  resource_group_name       = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
  depends_on                   = [azurerm_virtual_network.spoke1-vnet, azurerm_virtual_network.hub-vnet, azurerm_virtual_network_gateway.hub-vnet-gateway]
}

resource "azurerm_network_interface" "spoke1-nic" {
  name                 = "${local.prefix-spoke1}-nic"
  location             = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = local.prefix-spoke1
    subnet_id                     = azurerm_subnet.spoke1-mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
  
    tags = {
    environment = local.prefix-spoke1
  }
}

resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  name                         = "hub-spoke1-peer"
  resource_group_name          = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name         = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke1-vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
  depends_on                   = [azurerm_virtual_network.spoke1-vnet, azurerm_virtual_network.hub-vnet, azurerm_virtual_network_gateway.hub-vnet-gateway]
}