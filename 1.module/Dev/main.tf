module "resource_groups" {
  source          = "../../2.child module/1.azurerm_resource_group"
  resource_groups = var.resource_groups
}
module "virtual_networks" {
  source                  = "../../2.Child module/2.azurerm_vnet"
  depends_on              = [module.resource_groups]
  virtual_networks        = var.virtual_networks
  network_security_groups = var.network_security_groups
}
module "key_vaults" {
  source     = "../../2.Child module/3.azurerm_key_vault"
  depends_on = [module.resource_groups]
  key_vaults = var.key_vaults
}

module "sql_servers" {
  source        = "../../2.Child module/5.azurerm_mssql_server"
  depends_on    = [module.resource_groups, module.key_vaults]
  sql_servers   = var.sql_servers
  sql_databases = var.sql_databases
  user_assigned_identities = var.user_assigned_identities
}

module "kubernetes_clusters" {
  source               = "../../2.Child module/6.azurerm_kubernetes_cluster"
  depends_on           = [module.resource_groups, module.key_vaults, module.sql_servers]
  kubernetes_clusters = var.kubernetes_clusters
  container_registries = var.container_registries
}