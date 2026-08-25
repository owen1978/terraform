resource "azurerm_resource_group" "vmrg" {
  name     = var.vmrg_name
  location = var.vmrg_location
}

resource "azurerm_linux_virtual_machine" "webvm" {
  name                = var.webvm_name
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location
  size                = var.webvm_size
  admin_username      = var.webvm_admin
  network_interface_ids = [
    azurerm_network_interface.webvmnic.id,
  ]

  admin_ssh_key {
    username   = var.webvm_admin
    public_key = file("~/.ssh/azurekey.pub")
  }

  custom_data = filebase64("customdata.tpl")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.webvm_os_disk
  }

  source_image_reference {
    publisher = var.webvm_publisher
    offer     = var.webvm_offer
    sku       = var.webvm_sku
    version   = "latest"
  }
}
