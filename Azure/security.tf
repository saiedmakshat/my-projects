resource "azurerm_network_security_group" "sg_aks" {
    location = var.location
    name = "sg_aks"
    resource_group_name = azurerm_resource_group.rg.name
    depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_network_security_rule" "sg_rule_aks" {
    access = "value"
    direction = "Inbound"
    name = "sg_rule_aks"
    network_security_group_name = azurerm_network_security_group.sg_aks
    priority = 100
    protocol = "TCP"
    resource_group_name = azurerm_resource_group.rg.name
    depends_on = [ azurerm_network_security_group.sg_aks ]
    source_port_range = "22"
  
}