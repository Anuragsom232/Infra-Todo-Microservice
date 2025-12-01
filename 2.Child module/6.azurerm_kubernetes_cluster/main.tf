resource "azurerm_container_registry" "acr" {
  for_each            = var.container_registries
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  sku                 = each.value.sku
  admin_enabled       = each.value.admin_enabled
  tags                = each.value.tags
  dynamic "georeplications" {
    for_each = each.value.georeplications == null ? [] : each.value.georeplications
    content {
      location                = georeplications.value.location
      zone_redundancy_enabled = georeplications.value.zone_redundancy_enabled
      tags                    = georeplications.value.tags
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = var.kubernetes_clusters
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix

  dynamic "default_node_pool" {
    for_each = each.value.default_node_pool == null ? [] : [each.value.default_node_pool]
    content {
      name       = default_node_pool.value.name
      node_count = default_node_pool.value.node_count
      vm_size    = default_node_pool.value.vm_size
    }
  }
  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
      type = identity.value.type
    }
  }
  tags = each.value.tags
}

resource "azurerm_role_assignment" "acrrole" {
  for_each = var.kubernetes_clusters
  principal_id                     = azurerm_kubernetes_cluster.aks[each.key].identity[0].principal_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr[each.value.acr_key].id
  skip_service_principal_aad_check = true
}
