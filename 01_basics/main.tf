terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vnetrg" {
  name     = "rg-vnet-dev-uks"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_resource_group" "vmrg" {
  name     = "rg-web-dev-uks"
  location = "UK South"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "vnetweb" {
  name                = "vnet-web-dev-uks"
  resource_group_name = azurerm_resource_group.vnetrg.name
  location            = azurerm_resource_group.vnetrg.location
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "subnetweb" {
  name                 = "sub-web-dev-uks"
  resource_group_name  = azurerm_resource_group.vnetrg.name
  virtual_network_name = azurerm_virtual_network.vnetweb.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsgweb" {
  name                = "nsg-web-dev-uks"
  resource_group_name = azurerm_resource_group.vnetrg.name
  location            = azurerm_resource_group.vnetrg.location
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "weballow" {
  name                        = "allow-inbound-80"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vnetrg.name
  network_security_group_name = azurerm_network_security_group.nsgweb.name
}

resource "azurerm_subnet_network_security_group_association" "nsgwebrule" {
  subnet_id                 = azurerm_subnet.subnetweb.id
  network_security_group_id = azurerm_network_security_group.nsgweb.id
}

resource "azurerm_public_ip" "webvmpubip" {
  name                = "pubip-web-dev-uks"
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location
  allocation_method   = "Static"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "webvmnic" {
  name                = "nic-web-dev-uks"
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location
  tags = {
    environment = "dev"
  }

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetweb.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.webvmpubip.id
  }
}

resource "azurerm_linux_virtual_machine" "webvm" {
  name                = "vm-web-dev-uks"
  resource_group_name = azurerm_resource_group.vmrg.name
  location            = azurerm_resource_group.vmrg.location
  size                = "Standard_B2ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.webvmnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azurekey.pub")
  }

  custom_data = filebase64("customdata.tpl")

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}