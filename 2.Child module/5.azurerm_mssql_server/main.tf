resource "azurerm_user_assigned_identity" "UserID" {
  for_each            = var.user_assigned_identities
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_mssql_server" "SQLServer" {
  for_each                     = var.sql_servers
  name                         = each.value.name
  resource_group_name          = each.value.resource_group_name
  location                     = each.value.location
  version                      = each.value.version
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
  minimum_tls_version          = each.value.minimum_tls_version

  dynamic "azuread_administrator" {
    for_each = each.value.azuread_administrator == null ? [] : [each.value.azuread_administrator]
    content {
      login_username = azuread_administrator.value.login_username
      object_id      = azuread_administrator.value.object_id
    }
  }

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]
    content {
      type = "UserAssigned"
      identity_ids = [
        for id_key in identity.value.identity_keys :
        azurerm_user_assigned_identity.UserID[id_key].id
      ]
    }
  }

  tags = each.value.tags
}

resource "azurerm_mssql_database" "SQLDatabase" {
  for_each       = var.sql_databases
  name           = each.value.name
  server_id      = azurerm_mssql_server.SQLServer[each.value.server_key].id
  collation      = each.value.collation
  license_type   = each.value.license_type
  max_size_gb    = each.value.max_size_gb
  read_scale     = each.value.read_scale
  sku_name       = each.value.sku_name
  zone_redundant = each.value.zone_redundant
  enclave_type   = each.value.enclave_type
  tags           = each.value.tags

  dynamic "identity" {
    for_each = each.value.identity == null ? [] : [each.value.identity]

    content {
      type = "UserAssigned"
      identity_ids = [
        for id_key in identity.value.identity_ids :
        azurerm_user_assigned_identity.UserID[id_key].id
      ]
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_mssql_firewall_rule" "allow_access_to_azure_services" {
  for_each = {
    for server_name, server_details in var.sql_servers :
    server_name => server_details
    if server_details.allow_access_to_azure_services == true
  }

  name             = "allow_access_to_azure_services"
  server_id        = azurerm_mssql_server.SQLServer[each.key].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# output "db_connection_strings" {
#   description = "ODBC connection strings for all SQL databases"
#   value = {
#     for server_key, server in var.sql_databases :
#     server_key => {
#       for db_name in server.dbs :
#       db_name => "Driver={ODBC Driver 18 for SQL Server};Server=tcp:${server.name}.database.windows.net,1433;Database=${db_name};Uid=${server.administrator_login};Pwd=${server.administrator_login_password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
#     }
#   }
# }
output "db_connection_strings" {
  description = "ODBC connection strings for all SQL databases"
  value = {
    for db_key, db in var.sql_databases :
    db_key => "Driver={ODBC Driver 18 for SQL Server};Server=tcp:${var.sql_servers[db.server_key].name}.database.windows.net,1433;Database=${db.name};Uid=${var.sql_servers[db.server_key].administrator_login};Pwd=${var.sql_servers[db.server_key].administrator_login_password};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
  }
}
