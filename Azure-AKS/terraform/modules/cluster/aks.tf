# resource "azurerm_user_assigned_identity" "cluster_control_plane_identity" {
#   location            = var.resource_group_location
#   name                = "${var.azurerm_kubernetes_cluster_name}-controlplane"
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_kubernetes_cluster" "k8s" {
#   location                  = var.resource_group_location
#   name                      = var.azurerm_kubernetes_cluster_name
#   resource_group_name       = var.resource_group_name
#   dns_prefix                = var.azurerm_kubernetes_cluster_name
#   oidc_issuer_enabled       = true
#   workload_identity_enabled = true
#   #kubernetes_version = "value"
#   #private_cluster_enabled = false
#   #open_service_mesh_enabled = true
#   default_node_pool {
#     name       = "agentpool"
#     vm_size    = var.vm_size
#     node_count = var.node_count
#     #zones          = ["1", "2", "3"]
#     vnet_subnet_id = var.vnet_subnet_id
#     max_pods       = 250
#     # auto_scaling_enabled        = true
#     # min_count                   = 2
#     # max_count                   = 4
#   }

#   network_profile {
#     network_plugin = "azure"
#     network_policy = "azure" # calico, azure or none
#     # NOTE: When using 'userDefinedRouting', ensure a custom route table is associated with the subnet.
#     # For AKS outbound connectivity, add a route for 0.0.0.0/0 to Azure Firewall or NAT Gateway.
#     outbound_type = "userDefinedRouting"

#   }

#   ingress_application_gateway {
#     gateway_id = var.application_gateway_id
#   }

#   service_mesh_profile {
#     # Using Istio as the service mesh mode.
#     # Prerequisites: Ensure AKS supports Istio and the specified revision ("asm-1-27") is available in your region.
#     # Refer to Azure documentation for enabling Istio and required permissions.
#     mode                             = "Istio"
#     revisions                        = ["asm-1-27"]
#     internal_ingress_gateway_enabled = true
#     external_ingress_gateway_enabled = true
#   }

#   key_vault_secrets_provider {
#     # Enables automatic rotation of secrets from Azure Key Vault for enhanced security.
#     # The interval specifies how often secrets are rotated (here, every 5 minutes).
#     secret_rotation_enabled  = true
#     secret_rotation_interval = "5m"
#   }

#   tags = {
#     displayName = "Kubernetes Cluster"
#   }

#   # The AKS cluster uses a UserAssigned managed identity for control plane operations.
#   # Ensure this identity has the necessary RBAC permissions (e.g., Contributor on the resource group, Network Contributor on subnet, etc.)
#   # Only the control plane identity is assigned here.
#   # To assign additional identities (e.g., for node pools), add their resource IDs to the identity_ids list.
#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.cluster_control_plane_identity.id]
#   }
# }


# resource "azurerm_kubernetes_cluster_extension" "azure_keyvault_secrets_provider" {
#   name           = "azure-keyvault-secrets-provider"
#   cluster_id     = azurerm_kubernetes_cluster.k8s.id
#   extension_type = "AzureKeyVaultSecretsProvider"
# }

# output "aks_cluster_id" {
#   description = "The ID of the AKS cluster"
#   value       = azurerm_kubernetes_cluster.k8s.id
# }
# output "aks_cluster_name" {
#   description = "The name of the AKS cluster"
#   value       = azurerm_kubernetes_cluster.k8s.name
# }
# output "aks_cluster_fqdn" {
#   description = "The FQDN of the AKS cluster"
#   value       = azurerm_kubernetes_cluster.k8s.fqdn
# }
# output "aks_cluster_kube_config_raw" {
#   description = "The raw kube config of the AKS cluster"
#   value       = azurerm_kubernetes_cluster.k8s.kube_config_raw
# }
# output "aks_cluster_identity_principal_id" {
#   description = "The principal ID of the AKS cluster's control plane identity"
#   value       = azurerm_user_assigned_identity.cluster_control_plane_identity.principal_id
# }
# output "aks_cluster_identity_client_id" {
#   description = "The client ID of the AKS cluster's control plane identity"
#   value       = azurerm_user_assigned_identity.cluster_control_plane_identity.client_id
# }
# output "aks_cluster_identity_id" {
#   description = "The ID of the AKS cluster's control plane identity"
#   value       = azurerm_user_assigned_identity.cluster_control_plane_identity.id
# }




