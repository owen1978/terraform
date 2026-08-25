resource "azurerm_resource_group" "vmrg" {
  name     = var.vmrg_name
  location = var.vmrg_location
}

