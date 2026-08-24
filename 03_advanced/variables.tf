variable "resource_groups" {
  type = map(object({
    name     = string
    location = string
  }))
}

variable "virtual_network" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_space       = list(string)
    rg_key              = string
  }))
}
