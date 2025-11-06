resource "azurerm_virtual_network" "vnet" {
    address_space = [ "10.0.0.0/16" ]
    dns_servers = [ "10.0.0.4","10.0.0.5" ]
    location = var.location
    name = "vnet_nawras"
    resource_group_name = azurerm_resource_group.rg.name
    depends_on = [ azurerm_resource_group.rg ]

}

resource "azurerm_subnet" "private_subnet" {
    address_prefixes = [ "10.0.1.0/24" ]
    name = "private_subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet
    depends_on = [ azurerm_virtual_network.vnet ]
    
}
