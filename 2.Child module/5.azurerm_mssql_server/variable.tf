variable "user_assigned_identities" {
  description = "Map of user assigned identities"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "sql_servers" {
  description = "Map of SQL Server configurations"
  type = map(object({
    name                         = string
    resource_group_name          = string
    location                     = string
    version                      = string
    administrator_login          = string
    administrator_login_password = string
    minimum_tls_version          = string
    allow_access_to_azure_services = optional(bool, false)

    azuread_administrator = optional(object({
      login_username = string
      object_id      = string
    }))

    identity = optional(object({
      identity_keys = list(string)
    }))

    tags = map(string)
  }))
}

variable "sql_databases" {
  description = "Map of SQL Database configurations"
  type = map(object({
    name           = string
    server_key     = string              
    collation      = string
    license_type   = string
    max_size_gb    = number
    read_scale     = bool
    sku_name       = string
    zone_redundant = bool
    enclave_type   = string

    identity = optional(object({
      identity_ids = optional(list(string), [])
    }))

    tags = map(string)
  }))
}
