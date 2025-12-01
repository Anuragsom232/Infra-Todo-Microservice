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