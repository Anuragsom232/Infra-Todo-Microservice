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
