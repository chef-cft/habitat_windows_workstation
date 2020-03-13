terraform {
  required_version = "> 0.11.0"
}

locals {
  custom_data_params  = "Param($ComputerName = \"${var.tag_application}-sqlserver}\")"
  custom_data_content = "${local.custom_data_params} ${file("./files/windows_bootstrap.ps1")}"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.azure_sub_id}"
  tenant_id       = "${var.azure_tenant_id}"
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "rg" {
  name     = "${var.tag_application}-${var.contact_shortname}-rg"
  location = "${var.azure_region}"

  tags {
    X-Name        = "${var.tag_application}-${var.contact_shortname}-rg"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.tag_application}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  tags {
    X-Name        = "${var.tag_application}-${var.contact_shortname}-vnet"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.tag_application}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.10.0/24"
}

# Create public IPs  <-- Should this have a count > 1?
resource "azurerm_public_ip" "pip" {
  name                         = "${var.tag_application}-pip-${count.index}"
  location                     = "${var.azure_region}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "static"
  count                        = 1

  tags {
    X-Name        = "${var.tag_application}-${var.contact_shortname}-pip-${count.index}"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

