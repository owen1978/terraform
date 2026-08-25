# Resource Group
vnetrg_name     = "rg-vnet-dev-uks"
vnetrg_location = "UK South"

# Resource Group
vmrg_name     = "rg-web-dev-uks"
vmrg_location = "UK South"

# Virtual Network
vnetweb_name          = "vnet-web-dev-uks"
vnetweb_address_space = ["10.0.0.0/8"]

# Subnet
subnetweb_name             = "sub-web-dev-uks"
subnetweb_address_prefixes = ["10.0.1.0/24"]

#N etwork Security Group
nsgweb_name = "nsg-web-dev-uks"

# Network Security Group Rule
weballow_name                       = "allow-inbound-80"
weballow_priority                   = 1000
weballow_direction                  = "Inbound"
weballow_access                     = "Allow"
weballow_protocol                   = "Tcp"
weballow_source_port                = "*"
weballow_destination_port           = "80"
weballow_source_address_prefix      = "*"
weballow_destination_address_prefix = "*"

# Public IP
webvmpubip_name              = "pubip-web-dev-uks"
webvmpubip_allocation_method = "Static"

# Network Interface
webvmnic_name                = "nic-web-dev-uks"
webvmnic_ipconfig_name       = "Internal"
webvmnic_ipconfig_allocation = "Dynamic"

# Virtual Machine
webvm_name      = "vm-web-dev-uks"
webvm_size      = "Standard_B2ms"
webvm_admin     = "adminuser"
webvm_os_disk   = "Standard_LRS"
webvm_publisher = "Canonical"
webvm_offer     = "0001-com-ubuntu-server-jammy"
webvm_sku       = "22_04-lts"