# Create Network Security Group and rule
resource "azurerm_network_security_group" "hab-workstation" {
  name                = "hab-workstation-${random_id.instance_id.hex}-sg"
  location            = "${azurerm_resource_group.rg.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WinRm"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985-5986"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "OutBound"
    priority                   = 1004
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  // security_rule {
  //   name                       = "9631"
  //   priority                   = 1004
  //   direction                  = "Inbound"
  //   access                     = "Allow"
  //   protocol                   = "*"
  //   source_port_range          = "*"
  //   destination_port_range     = "9631"
  //   source_address_prefix      = "*"
  //   destination_address_prefix = "*"
  // }

  // security_rule {
  //   name                       = "9638"
  //   priority                   = 1005
  //   direction                  = "Inbound"
  //   access                     = "Allow"
  //   protocol                   = "*"
  //   source_port_range          = "*"
  //   destination_port_range     = "9638"
  //   source_address_prefix      = "*"
  //   destination_address_prefix = "*"
  // }

  tags {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}
