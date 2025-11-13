# terraform/main.tf
resource "azurerm_resource_group" "rg_ecommerce" {
  name     = "rg-ecommerce-${var.resource_group_location}"
  location = var.resource_group_location

  tags = {
    displayName = "Resource Group for general purpose"
  }
}

module "hub_network" {
  source                      = "./modules/hub_network"
  resource_group_location     = azurerm_resource_group.rg_ecommerce.location
  cluster_nodes_address_space = var.cluster_nodes_address_space
}

module "spoke_network" {
  source                  = "./modules/spoke_network"
  resource_group_location = azurerm_resource_group.rg_ecommerce.location
  application_id          = var.application_id
  #host_name                   = var.host_name
  cluster_nodes_address_space = var.cluster_nodes_address_space
  hub_fw_private_ip           = module.hub_network.hub_fw_private_ip
  #hub_fw_public_ip            = module.hub_network.hub_pip
  hub_fw_public_ip = module.hub_network.hub_fw_public_ip
  hub_vnet_id      = module.hub_network.hub_vnet_id
  hub_vnet_name    = module.hub_network.hub_vnet_name
  hub_rg_name      = module.hub_network.hub_rg_name

  depends_on = [module.hub_network]
}

# module "keyvault" {
#   source                      = "./modules/keyvault"
#   keyvault_name               = var.keyvault_name
#   location                    = var.resource_group_location
#   resource_group_name         = var.resource_group_name
#   service_principal_name      = var.service_principal_name
#   service_principal_object_id = module.ServicePrincipal.service_principal_object_id
#   service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

#   depends_on = [
#     module.ServicePrincipal
#   ]
# }

# resource "azurerm_key_vault_access_policy" "keyvault-principal" {
#   key_vault_id = module.keyvault.keyvault_id
#   tenant_id    = module.ServicePrincipal.service_principal_tenant_id
#   object_id    = module.ServicePrincipal.service_principal_tenant_id

#   secret_permissions = ["Set", "Get"]
#   depends_on         = [module.keyvault]
# }

module "cluster" {
  source = "./modules/cluster"

  resource_group_location = module.spoke_network.spoke_rg_location
  resource_group_name     = module.spoke_network.spoke_rg_name
  resource_group_id       = module.spoke_network.spoke_rg_id
  vnet_subnet_id          = module.spoke_network.cluster_nodes_subnet_id
  application_gateway_id  = module.spoke_network.application_gateway_id
  spoke_pip_id            = module.spoke_network.spoke_pip_id
  tenant_id               = var.tenant_id
  acr_name                = var.acr_name
  depends_on              = [module.spoke_network, module.hub_network]
}