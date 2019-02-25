variable "hub_resourcegroup_name" {
  default = "hub"
}

variable "hub_location" {
  default = "West Europe"
}

variable "hub_address_space" {
  default = "10.201.0.0/23"
}

variable "hub_fw_subnet_cidr" {
  default = "10.201.0.0/25"
}

variable "hub_gw_subnet_cidr" {
  default = "10.201.0.128/28"
}
