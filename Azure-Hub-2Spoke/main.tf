

# Resource Group
resource "azurerm_resource_group" "hub_spoke" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Hub Network
module "hub" {
  source                 = "./modules/hub"
  resource_group_name    = azurerm_resource_group.hub_spoke.name
  location               = azurerm_resource_group.hub_spoke.location
  hub_vnet_name          = "vnet-hub"
  hub_address_space      = ["10.0.0.0/16"]
  gateway_subnet_prefix  = ["10.0.0.0/24"]
  firewall_subnet_prefix = ["10.0.1.0/24"]
  bastion_subnet_prefix  = ["10.0.2.0/24"]
  mgmt_subnet_prefix     = ["10.0.3.0/24"]

  tags = var.tags
} # Azure Firewall (defined in root module to avoid circular dependencies)
resource "azurerm_public_ip" "fw_pip" {
  name                = "pip-fw"
  location            = azurerm_resource_group.hub_spoke.location
  resource_group_name = azurerm_resource_group.hub_spoke.name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}
resource "azurerm_firewall" "hub" {
  name                = "fw-hub"
  location            = azurerm_resource_group.hub_spoke.location
  resource_group_name = azurerm_resource_group.hub_spoke.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = var.tags
  ip_configuration {
    name                 = "fw-ip-config"
    subnet_id            = module.hub.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.fw_pip.id
  }
  depends_on = [module.hub]
} # First Spoke Network
module "spoke1" {
  source                 = "./modules/spoke"
  resource_group_name    = azurerm_resource_group.hub_spoke.name
  location               = azurerm_resource_group.hub_spoke.location
  spoke_vnet_name        = "vnet-spoke1"
  spoke_address_space    = ["10.1.0.0/16"]
  workload_subnet_prefix = ["10.1.0.0/24"]
  mgmt_subnet_prefix     = ["10.1.1.0/24"]

  hub_vnet_id                = module.hub.hub_vnet_id
  hub_vnet_name              = module.hub.hub_vnet_name
  firewall_private_ip        = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  remote_spoke_address_space = ["10.2.0.0/16"] # Pre-defined since we know it

  tags       = var.tags
  depends_on = [module.hub, azurerm_firewall.hub]
} # Second Spoke Network
module "spoke2" {
  source                 = "./modules/spoke"
  resource_group_name    = azurerm_resource_group.hub_spoke.name
  location               = azurerm_resource_group.hub_spoke.location
  spoke_vnet_name        = "vnet-spoke2"
  spoke_address_space    = ["10.2.0.0/16"]
  workload_subnet_prefix = ["10.2.0.0/24"]
  mgmt_subnet_prefix     = ["10.2.1.0/24"]

  hub_vnet_id                = module.hub.hub_vnet_id
  hub_vnet_name              = module.hub.hub_vnet_name
  firewall_private_ip        = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  remote_spoke_address_space = ["10.1.0.0/16"] # Pre-defined since we know it

  tags       = var.tags
  depends_on = [module.hub, azurerm_firewall.hub]
} # Firewall Rules (defined after spokes to avoid circular dependencies)
resource "azurerm_firewall_network_rule_collection" "allow_spoke_to_spoke" {
  name                = "allow-spoke-to-spoke"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub_spoke.name
  priority            = 100
  action              = "Allow"
  rule {
    name                  = "allow-spoke1-to-spoke2"
    source_addresses      = ["10.1.0.0/16"]
    destination_addresses = ["10.2.0.0/16"]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
  rule {
    name                  = "allow-spoke2-to-spoke1"
    source_addresses      = ["10.2.0.0/16"]
    destination_addresses = ["10.1.0.0/16"]
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
  depends_on = [module.spoke1, module.spoke2]
}
resource "azurerm_firewall_application_rule_collection" "allow_internet" {
  name                = "allow-internet"
  azure_firewall_name = azurerm_firewall.hub.name
  resource_group_name = azurerm_resource_group.hub_spoke.name
  priority            = 200
  action              = "Allow"
  rule {
    name             = "allow-http-https"
    source_addresses = ["10.1.0.0/16", "10.2.0.0/16"]
    target_fqdns     = ["*.microsoft.com", "*.azure.com", "*.windowsupdate.com"]
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }
  depends_on = [module.spoke1, module.spoke2]
}

module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.hub_spoke
  ]
}

resource "azurerm_role_assignment" "rolespn" {

  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}


module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "azurerm_key_vault_access_policy" "keyvault-principal" {
  key_vault_id = module.keyvault.keyvault_id
  tenant_id    = module.ServicePrincipal.service_principal_tenant_id
  object_id    = module.ServicePrincipal.service_principal_tenant_id

  secret_permissions = ["Set", "Get"]
  depends_on         = [module.keyvault]
}

# resource "azurerm_key_vault_secret" "kv-secret" {
#   name         = module.ServicePrincipal.client_id
#   value        = module.ServicePrincipal.client_secret
#   key_vault_id = module.keyvault.keyvault_id
#   depends_on = [
#     module.keyvault
#   ]
# }


# data "azurerm_client_config" "current" {}


# resource "azurerm_key_vault" "example" {
#   name                       = "examplekeyvault"
#   location                   = azurerm_resource_group.hub_spoke.location
#   resource_group_name        = azurerm_resource_group.hub_spoke.name
#   tenant_id                  = data.azurerm_client_config.current.tenant_id
#   sku_name                   = "premium"
#   soft_delete_retention_days = 7

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     key_permissions = [
#       "Create",
#       "Get",
#     ]

#     secret_permissions = [
#       "Set",
#       "Get",
#       "Delete",
#       "Purge",
#       "Recover"
#     ]
#   }
# }

# resource "azurerm_key_vault_secret" "example" {
#   name         = "secret-sauce"
#   value        = "szechuan"
#   key_vault_id = azurerm_key_vault.example.id
# }


#create Azure Kubernetes Service
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  #client_id              = var.client_id
  #client_secret          = var.client_secret
  location            = var.location
  resource_group_name = var.resource_group_name

  depends_on = [
    module.ServicePrincipal
  ]

}

resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.config

}

