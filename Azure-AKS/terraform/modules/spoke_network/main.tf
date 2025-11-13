# terraform/modules/spoke_network/main.tf
locals {
  spoke_vnet_name = "vnet-${var.resource_group_location}-spoke"
  spoke_rg_name   = "rg-spokes-${var.resource_group_location}"
  pip_name        = "pip-${var.application_id}-00"
}

resource "azurerm_resource_group" "rg_spoke_networks" {
  name     = local.spoke_rg_name
  location = var.resource_group_location
  tags = {
    displayName = "Resource Group for Spoke networks"
  }
}

resource "azurerm_virtual_network" "spoke_vnet" {
  name                = local.spoke_vnet_name
  location            = azurerm_resource_group.rg_spoke_networks.location
  resource_group_name = azurerm_resource_group.rg_spoke_networks.name
  address_space       = [var.spoke_vnet_address_space]
}

resource "azurerm_subnet" "cluster_nodes_subnet" {
  name                 = "snet-clusternodes"
  resource_group_name  = azurerm_resource_group.rg_spoke_networks.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = [var.cluster_nodes_address_space]
}

resource "azurerm_route_table" "spoke_route_table" {
  name                = "route-spoke-to-hub"
  location            = azurerm_resource_group.rg_spoke_networks.location
  resource_group_name = azurerm_resource_group.rg_spoke_networks.name
  route {
    name                   = "r-nexthop-to-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.hub_fw_private_ip
  }

  route {
    name           = "r-internet"
    address_prefix = "${var.hub_fw_public_ip}/32"
    next_hop_type  = "Internet"
  }
  #azure cli equivalent commands to create the routes above:by documantation
  #az network route-table route create 
  #--resource-group $RG 
  #--name $FWROUTE_NAME 
  #--route-table-name $FWROUTE_TABLE_NAME 
  #--address-prefix 0.0.0.0/0 
  #--next-hop-type VirtualAppliance 
  #--next-hop-ip-address $FWPRIVATE_IP

  #az network route-table route create 
  #--resource-group $RG 
  #--name $FWROUTE_NAME_INTERNET 
  #--route-table-name $FWROUTE_TABLE_NAME 
  #--address-prefix $FWPUBLIC_IP/32 
  #--next-hop-type Internet



  # add by AItional routes to allow AKS health probes and other services

  # route {
  #   name           = "r-azureloadbalancer"
  #   address_prefix = "AzureLoadBalancer"
  #   next_hop_type  = "Internet"
  # }
  # route {
  #   name           = "r-azurefirewall"
  #   address_prefix = "AzureFirewall"
  #   next_hop_type  = "Internet"
  # }
  # route {
  #   name           = "r-virtualnetwork"
  #   address_prefix = "VirtualNetwork"
  #   next_hop_type  = "VirtualNetwork"
  # }
  # route {
  #   name           = "r-privatelink"
  #   address_prefix = "AzurePrivateLinkService"
  #   next_hop_type  = "Internet"
  # }
  # route {
  #   name           = "r-privatedns"
  #   address_prefix = "AzurePrivateDNSZone"
  #   next_hop_type  = "Internet"
  # }
}

resource "azurerm_subnet_route_table_association" "cluster_nodes_route_table" {
  subnet_id      = azurerm_subnet.cluster_nodes_subnet.id
  route_table_id = azurerm_route_table.spoke_route_table.id
}

resource "azurerm_subnet" "application_gateways_subnet" {
  name                 = "snet-application-gateways"
  resource_group_name  = azurerm_resource_group.rg_spoke_networks.name
  virtual_network_name = azurerm_virtual_network.spoke_vnet.name
  address_prefixes     = [var.application_gateways_address_space]
}

resource "azurerm_public_ip" "spoke_pip" {
  name                    = local.pip_name
  location                = azurerm_resource_group.rg_spoke_networks.location
  resource_group_name     = azurerm_resource_group.rg_spoke_networks.name
  allocation_method       = "Static"
  sku                     = "Standard"
  zones                   = ["1", "2", "3"]
  idle_timeout_in_minutes = 4
}