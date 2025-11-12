resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = var.resource_group_location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  purge_protection_enabled    = false
  sku_name                    = "premium"
  soft_delete_retention_days  = 7
  #enable_rbac_authorization = true

}

resource "azurerm_role_assignment" "key_vault_role_assignment" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id # Or a user/group object ID
}