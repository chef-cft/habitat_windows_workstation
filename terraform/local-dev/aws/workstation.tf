resource "aws_instance" "workstation" {
  count                       = var.workstations
  ami                         = data.aws_ami.windows_workstation.id
  instance_type               = var.aws_instance_type
  key_name                    = var.aws_key_pair_name
  subnet_id                   = aws_subnet.habworkshop-subnet.id
  vpc_security_group_ids      = [aws_security_group.habworkshop.id]
  associate_public_ip_address = true

  root_block_device {
    delete_on_termination = true
    volume_size           = 100
    volume_type           = "gp2"
  }

  tags = {
    Name          = "${var.tag_contact}-${var.tag_customer}-habworkshop-${count.index}"
    X-Dept        = var.tag_dept
    X-Customer    = var.tag_customer
    X-Project     = var.tag_project
    X-Application = var.tag_application
    X-Contact     = var.tag_contact
    X-TTL         = var.tag_ttl
  }

  provisioner "local-exec" {
     command = "sleep 60"
  }

  provisioner "remote-exec" {
    connection {
    type     = "winrm"
    user     = "hab"
    password = "ch3fh@b1!"
    host     = coalesce(self.public_ip, self.private_ip)
    insecure = true
    agent     = "false"
    https     = false
    }
    inline = [
      "cmd.exe /c net user Administrator ${var.admin_password}",
    ]
  }


  # provisioner "remote-exec" {
  #   connection = {
  #     type     = "winrm"
  #     password = ""
  #     agent    = "false"
  #     insecure = true
  #     https    = false
  #   }

  #   inline = [
  #     "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  #   ]
  # }
}

