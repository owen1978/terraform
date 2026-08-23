output "name" {
  value = azurerm_virtual_network.this.name
}

output "location" {
  value = azurerm_virtual_network.this.location
}

output "resource_group_name" {
  value = azurerm_virtual_network.this.resource_group_name
}
output "address_space" {
  value = azurerm_virtual_network.this.address_space
}
