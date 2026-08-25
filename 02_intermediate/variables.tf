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

variable "weballow_name" {
  type = string
}

variable "weballow_priority" {
  type = number
}

variable "weballow_direction" {
  type = string
}

variable "weballow_access" {
  type = string
}

variable "weballow_protocol" {
  type = string
}

variable "weballow_source_port" {
  type = string
}

variable "weballow_destination_port" {
  type = string
}

variable "weballow_source_address_prefix" {
  type = string
}

variable "weballow_destination_address_prefix" {
  type = string
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
