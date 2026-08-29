variable "subscription_id" {
  type    = string
  default = null
}

variable "tags" {
  type        = map(string)
}

variable "vmrg_name" {
  type = string
}

variable "vmrg_location" {
  type = string
}

variable "vnetrg_name" {
  type = string
}

variable "vnetrg_location" {
  type = string
}

variable "vnetweb_name" {
  type = string
}

variable "vnetweb_address_space" {
  type = list(string)
}

variable "subnetweb_name" {
  type = string
}

variable "subnetweb_address_prefixes" {
  type = list(string)
}

variable "nsgweb_name" {
  type = string
}

variable "web_nsg_rule" {
  type = object({
    name                       = string
    priority                   = number
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  })
  description = "Inbound allow rule for the web NSG. Direction/access/protocol aren't exposed here since this rule only ever allows inbound HTTP."
}

variable "webvmpubip_name" {
  type = string
}

variable "webvmpubip_allocation_method" {
  type = string
}

variable "webvmnic_name" {
  type = string
}

variable "webvmnic_ipconfig_name" {
  type = string
}

variable "webvmnic_ipconfig_allocation" {
  type = string
}

variable "webvm_name" {
  type = string
}

variable "webvm_size" {
  type = string
}

variable "webvm_admin" {
  type = string
}

variable "webvm_os_disk" {
  type = string
}

variable "webvm_publisher" {
  type = string
}

variable "webvm_offer" {
  type = string
}

variable "webvm_sku" {
  type = string
}
