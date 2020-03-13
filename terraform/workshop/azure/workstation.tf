resource "azurerm_public_ip" "workstation_pip" {
  name                = "hab-workstation-${random_id.instance_id.hex}-pip"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "workstation_nic" {
  name                      = "hab-workstation-${random_id.instance_id.hex}-nic"
  location                  = "${azurerm_resource_group.rg.location}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  network_security_group_id = "${azurerm_network_security_group.hab-workstation.id}"

  ip_configuration {
    name                          = "workstation-ip-config"
    subnet_id                     = "${azurerm_subnet.hab-workstation.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.workstation_pip.id}"
  }

  tags {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}
// where we left off, to be continued
resource "azurerm_virtual_machine" "chef_automate" {
  name                  = "${var.automate_hostname}"
  location              = "${azurerm_resource_group.rg.location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  availability_set_id   = "${azurerm_availability_set.avset.id}"
  network_interface_ids = ["${azurerm_network_interface.workstation_nic.id}"]
  vm_size               = "${var.automate_server_instance_type}"
  delete_os_disk_on_termination = true

  connection {
    type        = "ssh"
    user        = "${var.azure_image_user}"
    private_key = "${file("${var.azure_private_key_path}")}"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.automate_hostname}-fe-${random_id.randomId.hex}-osdisk"
    vhd_uri       = "${azurerm_storage_account.stor.primary_blob_endpoint}${azurerm_storage_container.storcont.name}/${var.tag_application}-chef_automate-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = "100"
  }

  os_profile {
    computer_name  = "${var.automate_hostname}"
    admin_username = "${var.azure_image_user}"
    admin_password = "${var.azure_image_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.azure_image_user}/.ssh/authorized_keys"
      key_data = "${file("${var.azure_public_key_path}")}"
    }
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }

  provisioner "file" {
    destination = "/tmp/install_chef_automate_cli.sh"
    content     = "${data.template_file.install_chef_automate_cli.rendered}"
  }

  provisioner "file" {
    destination = "/tmp/ssl_cert"
    content = "${var.automate_custom_ssl ? var.automate_custom_ssl_cert_chain : local.full_cert_chain}"
  }

  provisioner "file" {
    destination = "/tmp/ssl_key"
    content = "${var.automate_custom_ssl ? var.automate_custom_ssl_private_key : acme_certificate.automate_cert.private_key_pem}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sysctl -w vm.max_map_count=262144",
      "sudo sysctl -w vm.dirty_expire_centisecs=20000",
      "curl https://packages.chef.io/files/current/latest/chef-automate-cli/chef-automate_linux_amd64.zip |gunzip - > chef-automate && chmod +x chef-automate",
      "sudo chmod +x /tmp/install_chef_automate_cli.sh",
      "sudo bash /tmp/install_chef_automate_cli.sh",
      "sudo ./chef-automate init-config --file /tmp/config.toml --certificate /tmp/ssl_cert --private-key /tmp/ssl_key",
      "sudo sed -i 's/fqdn = \".*\"/fqdn = \"${var.automate_hostname}.${var.automate_app_gateway_dns_zone}\"/g' /tmp/config.toml",
      "sudo sed -i 's/channel = \".*\"/channel = \"${var.channel}\"/g' /tmp/config.toml",
      "sudo sed -i 's/license = \".*\"/license = \"${var.automate_license}\"/g' /tmp/config.toml",
      "sudo rm -f /tmp/ssl_cert /tmp/ssl_key",
      "sudo mv /tmp/config.toml /etc/chef-automate/config.toml",
      "sudo ./chef-automate deploy /etc/chef-automate/config.toml --accept-terms-and-mlsa",
      "sudo chown ${var.azure_image_user}:${var.azure_image_user} $HOME/automate-credentials.toml",
      "sudo echo -e api-token = \"$(sudo chef-automate admin-token)\" >> $HOME/automate-credentials.toml",
      "sudo cat $HOME/automate-credentials.toml",
    ]
  }

  provisioner "local-exec" {
    // Clean up local known_hosts in case we get a re-used public IP
    command = "ssh-keygen -R ${azurerm_public_ip.workstation_pip.ip_address}"
  }

  provisioner "local-exec" {
    // Write ssh key for Automate server to local known_hosts so we can scp automate-credentials.toml in data.external.a2_secrets
    command = "ssh-keyscan -t ecdsa ${azurerm_public_ip.workstation_pip.ip_address} >> ~/.ssh/known_hosts"
  }

  tags {
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}

data "external" "a2_secrets" {
  program = ["bash", "${path.module}/data-sources/get-automate-secrets.sh"]
  depends_on = ["azurerm_virtual_machine.chef_automate"]

  query = {
    ssh_user = "${var.azure_image_user}"
    ssh_key  = "${var.azure_private_key_path}"
    a2_ip    = "${azurerm_public_ip.workstation_pip.ip_address}"
  }
}
