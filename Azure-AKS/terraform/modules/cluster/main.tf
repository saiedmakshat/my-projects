resource "azurerm_user_assigned_identity" "cluster_control_plane_identity" {
  location            = var.resource_group_location
  name                = "${var.azurerm_kubernetes_cluster_name}-controlplane"
  resource_group_name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.resource_group_location
  name                = var.azurerm_kubernetes_cluster_name
  resource_group_name = var.resource_group_name
  dns_prefix          = var.azurerm_kubernetes_cluster_name
  # Enable OIDC issuer for Kubernetes cluster to support workload identity federation.
  # Prerequisites: Azure AD integration and proper RBAC configuration may be required.
  # Downstream effects: Allows pods to access Azure resources securely using federated identity.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  kubernetes_version        = "1.34.0"

  # api_server_access_profile {
  #   authorized_ip_ranges = [anytrue(var.authorized_ip_ranges) ? var.authorized_ip_ranges : "0.0.0.0/0"]
  #     }
  #private_cluster_enabled = false
  #open_service_mesh_enabled = true

  service_mesh_profile {
    mode                             = "Istio"
    revisions                        = ["asm-1-27"]
    internal_ingress_gateway_enabled = true
    external_ingress_gateway_enabled = true

  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "5m"
  }

  tags = {
    displayName = "Kubernetes Cluster"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.cluster_control_plane_identity.id]
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = var.vm_size
    node_count = var.node_count
    #zones          = ["1", "2", "3"]
    vnet_subnet_id = var.vnet_subnet_id
    max_pods       = 250
    # auto_scaling_enabled        = true
    # min_count                   = 2
    # max_count                   = 4
    temporary_name_for_rotation = "temp220681"
  }

  network_profile {
    network_plugin = "azure"              # Options: azure, kubenet, cilium
    network_policy = "calico"             # Options: calico, azure, cilium
    outbound_type  = "userDefinedRouting" # Options: loadBalancer, userDefinedRouting
  }

  ingress_application_gateway {
    gateway_id = var.application_gateway_id
  }
}



