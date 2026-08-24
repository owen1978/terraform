# We strongly recommend using the required_providers block to set the Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # hashicorp/(Namespace): Indicates an Official Provider. HashiCorp either owns it directly or maintains it as an official Tier 1 partnership (e.g., AWS, Azure, GCP).
      # azurerm (Name): The actual plugin binary managing Azure Resource Manager APIs.
      version = "=2.91.0"
      # Version controls which version of the Azure API Terraform communicates with under the hood.
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" { # you tell it what resource your creating and then give it an alias which is used by terraform only
  name     = "rg-dev-test-we"
  location = "West Europe"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "dev_vnet1_we"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  address_space       = ["10.0.0.0/16", "172.16.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "sub1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "All" {
  name                        = "All"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "86.150.74.211/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg1.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_subnet_network_security_group_association" "nsg1rdp" {
  subnet_id                 = azurerm_subnet.sub1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_public_ip" "vm1-pubip" {
  name                = "vm1-pubip"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  allocation_method   = "Static"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "vm1-nic" {
  name                = "vm1-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags = {
    environment = "dev"
  }
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1-pubip.id
  }

}
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = "Standard_B1ms"
  custom_data         = filebase64("customdata.tpl")
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/azurekey.pub")
  }
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

data "azurerm_public_ip" "vmpubip-data" {
  name                = azurerm_public_ip.vm1-pubip.name
  resource_group_name = azurerm_resource_group.rg1.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.vm1.name}: ${data.azurerm_public_ip.vmpubip-data.ip_address}"
}