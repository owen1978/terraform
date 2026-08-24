module "rg" {
  source   = "./_modules/azure/resource_group"
  for_each = var.resource_groups
  name     = each.value.name
  location = each.value.location
}

module "vnet" {
  source              = "./_modules/azure/virtual_network"
  for_each            = var.virtual_network
  name                = each.value.name
  location            = each.value.location
  resource_group_name = module.rg[each.value.rg_key].name
  address_space       = each.value.address_space
  rg_key              = each.value.rg_key
}