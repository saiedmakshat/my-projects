# resource "azurerm_firewall_policy" "firewall-policy" {
#   location            = azurerm_resource_group.rg_hub_networks.location
#   name                = var.azure_firewall_policy_name
#   resource_group_name = azurerm_resource_group.rg_hub_networks.name
#   sku                 = "Premium" # [Basic , Standard, Premium]
#   dns {
#     #servers       = ["Default"] #Default (Azure provided)
#     proxy_enabled = true
#   }
#   # tls_certificate {
#   #     name = "value"
#   #   key_vault_secret_id = "value"
#   # }
#   intrusion_detection {
#     mode = "Deny"
#   }
#   # threat_intelligence_mode = "Alert"
#   # threat_intelligence_allowlist {
#   #   fqdns = [ "value" ]
#   #   ip_addresses = [ "value" ]
#   # }
#   # auto_learn_private_ranges_enabled = true
# }



# resource "azurerm_firewall_policy_rule_collection_group" "firewall_policy_rule" {
#   name               = "hub-fwpolicy-rcg"
#   firewall_policy_id = azurerm_firewall_policy.firewall-policy.id
#   priority           = 500
#   network_rule_collection {
#     name = "org-wide-allowed"

#     priority = 100
#     action   = "Allow"
#     rule {
#       name                  = "dns"
#       protocols             = ["UDP"]
#       source_addresses      = ["*"]
#       destination_ports     = ["53"]
#       destination_addresses = ["*"]
#     }
#     rule {
#       name                  = "ntp"
#       description           = "Network Time Protocol (NTP) time synchronization"
#       protocols             = ["UDP"]
#       source_addresses      = ["*"]
#       destination_ports     = ["123"]
#       destination_addresses = ["*"]
#     }
#   }
#   network_rule_collection {
#     name     = "aks-global-network-requirements"
#     priority = 200
#     action   = "Allow"
#     rule {
#       name                  = "tunnel-front-pod-tcp"
#       source_ip_groups      = [azurerm_ip_group.aks_ip_group]
#       protocols             = ["TCP"]
#       destination_ports     = ["22", "9000"]
#       destination_addresses = ["AzureCloud"]
#     }
#     rule {
#       name                  = "tunnel-front-pod-udp"
#       source_ip_groups      = [azurerm_ip_group.aks_ip_group]
#       protocols             = ["UDP"]
#       destination_ports     = ["1194", "123"]
#       destination_addresses = ["AzureCloud"]
#     }
#     rule {
#       name                  = "managed-k8s-api-tcp-443"
#       source_ip_groups      = [azurerm_ip_group.aks_ip_group]
#       protocols             = ["TCP"]
#       destination_ports     = ["443"]
#       destination_addresses = ["AzureCloud"]
#     }
#     rule {
#       name              = "docker.io"
#       source_ip_groups  = [azurerm_ip_group.]
#       protocols         = ["TCP"]
#       destination_ports = ["443"]
#       destination_fqdns = ["docker.io"]
#     }
#     rule {
#       name              = "registry-1.docker.io"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       protocols         = ["TCP"]
#       destination_ports = ["443"]
#       destination_fqdns = ["registry-1.docker.io"]
#     }
#     rule {
#       name              = "production.cloudflare.docker.com"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       protocols         = ["TCP"]
#       destination_ports = ["443"]
#       destination_fqdns = ["production.cloudflare.docker.com"]
#     }
#     rule {
#       name              = "ghcr.io"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       protocols         = ["TCP"]
#       destination_ports = ["443"]
#       destination_fqdns = ["ghcr.io"]
#     }
#     rule {
#       name              = "quay.io"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       protocols         = ["TCP"]
#       destination_ports = ["443"]
#       destination_fqdns = ["quay.io"]
#     }
#   }

#   application_rule_collection {
#     name     = "aks-global-application-requirements"
#     priority = 200
#     action   = "Allow"
#     rule {
#       name             = "nodes-to-api-server"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "*.hcp.${azurerm_resource_group.rg_hub_networks.location}.azmk8s.io",
#         "*.tun.${azurerm_resource_group.rg_hub_networks.location}.azmk8s.io"
#       ]
#       protocols {
#         port = 443
#         type = "Https"
#       }
#     }
#     rule {
#       name             = "microsoft-container-registry"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "*.cdn.mscr.io",
#         "mcr.microsoft.com",
#         "*.data.mcr.microsoft.com"
#       ]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name              = "management-plane"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = ["management.azure.com"]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name              = "aad-auth"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = ["login.microsoftonline.com"]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name              = "apt-get"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = ["packages.microsoft.com"]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name              = "cluster-binaries"
#       source_ip_groups  = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = ["acs-mirror.azureedge.net"]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name             = "ubuntu-security-patches"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "security.ubuntu.com",
#         "azure.archive.ubuntu.com",
#         "changelogs.ubuntu.com"
#       ]
#       protocols {
#         port = "80"
#         type = "Http"
#       }
#     }
#     rule {
#       name             = "azure-monitor"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "dc.services.visualstudio.com",
#         "*.ods.opinsights.azure.com",
#         "*.oms.opinsights.azure.com",
#         "*.microsoftonline.com",
#         "*.monitoring.azure.com"
#       ]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     rule {
#       name             = "azure-policy"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "gov-prod-policy-data.trafficmanager.net",
#         "raw.githubusercontent.com",
#         "dc.services.visualstudio.com",
#         "data.policy.core.windows.net",
#         "store.policy.core.windows.net"
#       ]
#       protocols {
#         port = "443"
#         type = "Https"
#       }
#     }
#     #   rule {
#     #     name             = "azure-kubernetes-service"
#     #     source_ip_groups = [azurerm_ip_group.aks_ip_group.id]

#     #     fqdn_tags        = ["AzureKubernetesService"]
#     #   }
#     rule {
#       name             = "allow-acr"
#       source_ip_groups = [azurerm_ip_group.aks_ip_group.id]
#       destination_fqdns = [
#         "*.azurecr.io",
#         "*.data.azurecr.io"
#       ]
#       protocols {
#         port = 443
#         type = "Https"
#       }
#     }



#     #   nat_rule_collection {
#     #     name     = "nat_rule_collection1"
#     #     priority = 300
#     #     action   = "Dnat"
#     #     rule {
#     #       name                = "nat_rule_collection1_rule1"
#     #       protocols           = ["TCP", "UDP"]
#     #       source_addresses    = ["10.0.0.1", "10.0.0.2"]
#     #       destination_address = "192.168.1.1"
#     #       destination_ports   = ["80"]
#     #       translated_address  = "192.168.0.1"
#     #       translated_port     = "8080"
#     #     }
#     #   }
#   }
# }