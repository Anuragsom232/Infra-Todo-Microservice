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