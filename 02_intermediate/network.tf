resource "azurerm_resource_group" "vnetrg" {
  name     = var.vnetrg_name
  location = var.vnetrg_location
}

resource "azurerm_virtual_network" "vnetweb" {
  name                = var.vnetweb_name
  resource_group_name = azurerm_resource_group.vnetrg.name
  location            = azurerm_resource_group.vnetrg.location
  address_space       = var.vnetweb_address_space
}

resource "azurerm_subnet" "subnetweb" {
  name                 = var.subnetweb_name
  resource_group_name  = azurerm_resource_group.vnetrg.name
  virtual_network_name = azurerm_virtual_network.vnetweb.name
  address_prefixes     = var.subnetweb_address_prefixes
}

resource "azurerm_network_security_group" "nsgweb" {
  name                = var.nsgweb_name
  resource_group_name = azurerm_resource_group.vnetrg.name
  location            = azurerm_resource_group.vnetrg.location
}

resource "azurerm_network_security_rule" "weballow" {
  name                        = var.weballow_name
  priority                    = var.weballow_priority
  direction                   = var.weballow_direction
  access                      = var.weballow_access
  protocol                    = var.weballow_protocol
  source_port_range           = var.weballow_source_port
  destination_port_range      = var.weballow_destination_port
  source_address_prefix       = var.weballow_source_address_prefix
  destination_address_prefix  = var.weballow_destination_address_prefix
  resource_group_name         = azurerm_resource_group.vnetrg.name
  network_security_group_name = azurerm_network_security_group.nsgweb.name
}

resource "azurerm_subnet_network_security_group_association" "nsgwebrule" {
  subnet_id                 = azurerm_subnet.subnetweb.id
  network_security_group_id = azurerm_network_security_group.nsgweb.id
}

resource "azurerm_public_ip" "webvmpubip" {
  name                = var.webvmpubip_name
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location
  allocation_method   = var.webvmpubip_allocation_method
}

resource "azurerm_network_interface" "webvmnic" {
  name                = var.webvmnic_name
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location

  ip_configuration {
    name                          = var.webvmnic_ipconfig_name
    subnet_id                     = azurerm_subnet.subnetweb.id
    private_ip_address_allocation = var.webvmnic_ipconfig_allocation
    public_ip_address_id          = azurerm_public_ip.webvmpubip.id
  }
}
