resource "azurerm_resource_group" "hub-rg" {
  name     = "${var.hub_resourcegroup_name}"
  location = "${var.hub_location}"
}

resource "azurerm_virtual_network" "hub" {
  name                = "hub"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"
  location            = "${var.hub_location}"

  address_space = [
    "${var.hub_address_space}",
  ]
}

resource "azurerm_public_ip" "hub-pip" {
  name                = "hub-pip"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"
  location            = "${var.hub_location}"

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_route_table" "spoke-rt" {
  name                = "spoke-rt"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"
  location            = "${var.hub_location}"
}

// This NEEDS to be called AzureFirewallSubnet
resource "azurerm_subnet" "hub-fw-subnet" {
  name                = "AzureFirewallSubnet"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"

  address_prefix       = "${var.hub_fw_subnet_cidr}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
}

resource "azurerm_firewall" "hub-firewall" {
  name                = "hub-firewall"
  location            = "${azurerm_resource_group.hub-rg.location}"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${azurerm_subnet.hub-fw-subnet.id}"
    public_ip_address_id = "${azurerm_public_ip.hub-pip.id}"
  }
}

// This NEEDS to be called GatewaySubnet
resource "azurerm_subnet" "hub-gw-subnet" {
  name                = "GatewaySubnet"
  resource_group_name = "${azurerm_resource_group.hub-rg.name}"

  address_prefix       = "${var.hub_gw_subnet_cidr}"
  virtual_network_name = "${azurerm_virtual_network.hub.name}"
}
