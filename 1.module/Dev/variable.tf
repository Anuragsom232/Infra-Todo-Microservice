
variable "resource_groups" {
  type = map(object({
    name       = string
    location   = string
    managed_by = string
    tags       = map(string)
  }))
}

variable "network_security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    tags                = map(string)
  }))
}


variable "virtual_networks" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    dns_servers         = list(string)
    subnets = map(object({
      name             = string
      address_prefixes = list(string)
      security_group   = optional(string)
    }))
    tags = map(string)
  }))
}

variable "key_vaults" {
  description = "A map of Key Vaults to create"
  type = map(object({
    name                        = string
    location                    = string
    resource_group_name         = string
    enabled_for_disk_encryption = bool
    soft_delete_retention_days  = number
    purge_protection_enabled    = bool
    sku_name                    = string
    tags                        = map(string)
  }))
}

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

variable "container_registries" {
  description = "A map of container registries to create."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    sku                 = string
    admin_enabled       = optional(bool, false)
    tags                = map(string)
    georeplications = optional(list(object({
      location                = string
      zone_redundancy_enabled = optional(bool, false)
      tags                    = map(string)
    })), null)
  }))
}

variable "kubernetes_clusters" {
  description = "A map of Kubernetes clusters to create."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    dns_prefix          = string
    acr_key             = string
    default_node_pool = optional(object({
      name       = string
      node_count = number
      vm_size    = string
    }), null)
    identity = optional(object({
      type = string
    }), null)
    tags = map(string)
  }))
}
