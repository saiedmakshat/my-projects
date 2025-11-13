resource "azurerm_container_registry" "acr-k8s" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "Premium"

}

resource "azurerm_role_assignment" "container_registry_role_assignment" {
  scope                = azurerm_container_registry.acr-k8s.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  #skip_service_principal_aad_check = true
}
