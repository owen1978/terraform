resource "azurerm_resource_group" "vnetrg" {
  name     = var.vnetrg_name
  location = var.vnetrg_location
}