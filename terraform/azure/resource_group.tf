terraform {
  required_version = "> 0.11.0"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id         = "${var.azure_sub_id}"
  tenant_id               = "${var.azure_tenant_id}"
}

resource "random_id" "instance_id" {
  byte_length = 4
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "rg" {
  name     = "hab-workstation-${random_id.instance_id.hex}-rg"
  location = "${var.azure_region}"

  tags {
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
  name                = "hab-workstation-${random_id.instance_id.hex}-vnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  address_space       = ["10.0.0.0/16"]

  tags {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

# Create subnets
resource "azurerm_subnet" "subnet" {
  name                 = "hab-workstation-${random_id.instance_id.hex}-subnet"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.10.0/24"
}


# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = "${azurerm_resource_group.rg.name}"
  }

  byte_length = 8
}

////////////////////
// Storage for VHDs to make cleanup easy

resource "azurerm_storage_account" "stor" {
  name                     = "stor${random_id.randomId.hex}"
  resource_group_name      = "${azurerm_resource_group.rg.name}"
  location                 = "${azurerm_resource_group.rg.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}
resource "azurerm_storage_container" "storcont" {
  name 		              = "vhds"
  resource_group_name 	= "${azurerm_resource_group.rg.name}"
  storage_account_name 	= "${azurerm_storage_account.stor.name}"
  container_access_type = "private"
}
