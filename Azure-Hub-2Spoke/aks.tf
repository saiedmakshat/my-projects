# resource "random_id" "prefix" {
#   byte_length = 8
# }

# resource "azurerm_virtual_network" "test" {
#   address_space       = ["10.52.0.0/16"]
#   location            = var.location
#   name                = "${random_id.prefix.hex}-vn"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_subnet" "default_node_pool_subnet" {
#   address_prefixes                              = ["10.52.0.0/24"]
#   name                                          = "${random_id.prefix.hex}-defaultsn"
#   resource_group_name                           = var.resource_group_name
#   virtual_network_name                          = azurerm_virtual_network.test.name
#   private_endpoint_network_policies             = "Disabled"
#   private_link_service_network_policies_enabled = true
# }

# resource "azurerm_subnet" "node_pool_subnet" {
#   count                                         = 3
#   address_prefixes                              = ["10.52.${count.index + 1}.0/24"]
#   name                                          = "${random_id.prefix.hex}-sn${count.index}"
#   resource_group_name                           = var.resource_group_name
#   virtual_network_name                          = azurerm_virtual_network.test.name
#   private_endpoint_network_policies             = "Disabled"
#   private_link_service_network_policies_enabled = true
# }

# locals {
#   nodes = {
#     for i in range(3) : "worker${i}" => {
#       name                  = substr("worker${i}${random_id.prefix.hex}", 0, 8)
#       vm_size               = "Standard_D2s_v3"
#       node_count            = 1
#       vnet_subnet           = { id = azurerm_subnet.node_pool_subnet[i].id }
#       create_before_destroy = i % 2 == 0
#       upgrade_settings = {
#         drain_timeout_in_minutes      = 0
#         node_soak_duration_in_minutes = 0
#         max_surge                     = "10%"
#       }
#     }
#   }
# }

# module "aks" {
#   source = "./modules/aks"

#   client_id = var.client_id
#   client_secret = var.client_secret
#   service_principal_name = var.service_principal_name
#   #prefix                  = "prefix-${random_id.prefix.hex}"
#   resource_group_name     = var.resource_group_name
#   location                = var.location
#   #os_disk_size_gb         = 60
#   #sku_tier                = "Standard"
#   #private_cluster_enabled = false
#   # vnet_subnet = {
#   #   id = azurerm_subnet.default_node_pool_subnet.id
#   # }
#   # node_pools                                 = local.nodes
#   # kubernetes_version                         = var.kubernetes_version
#   # orchestrator_version                       = var.orchestrator_version
#   # create_role_assignment_network_contributor = true
# }