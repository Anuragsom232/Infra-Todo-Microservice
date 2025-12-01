resource "azurerm_network_security_group" "NSG" {
  for_each            = var.network_security_groups
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  tags                = each.value.tags
}

resource "azurerm_virtual_network" "VNET" {
  for_each            = var.virtual_networks
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_space
  dns_servers         = each.value.dns_servers

  dynamic "subnet" {
    for_each = each.value.subnets
    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefixes
      security_group   = subnet.value.security_group == null ? null : azurerm_network_security_group.NSG[subnet.value.security_group].id
    }
  }
  tags = each.value.tags
}
