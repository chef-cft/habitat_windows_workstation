resource "aws_security_group" "habworkshop" {
  name        = "habworkshop-${random_id.instance_id.hex}"
  description = "Security group for Habitat workshop for Windows"
  vpc_id      = "${aws_vpc.habworkshop-vpc.id}"

  tags {
    Name          = "${var.tag_customer}-${var.tag_project}-${random_id.instance_id.hex}-${var.tag_application}-security_group"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Application = "${var.tag_application}"
    X-Contact     = "${var.tag_contact}"
    X-TTL         = "${var.tag_ttl}"
  }
}


//////////////////////////
// Base Windows Rules
# RDP - all
resource "aws_security_group_rule" "ingress_rdp_all" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.habworkshop.id}"
}

# WinRM - all
resource "aws_security_group_rule" "ingress_winrm_all" {
  type              = "ingress"
  from_port         = 5985
  to_port           = 5986
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.habworkshop.id}"
}

# resource "aws_security_group_rule" "ingress_allow_9631_tcp" {
#   type                     = "ingress"
#   from_port                = 9631
#   to_port                  = 9631
#   protocol                 = "tcp"
#   cidr_blocks              = ["0.0.0.0/0"]
#   security_group_id        = "${aws_security_group.habworkshop.id}"
#   source_security_group_id = "${aws_security_group.habworkshop.id}"
# }

resource "aws_security_group_rule" "windows_egress_allow_0-65535_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.habworkshop.id}"
}



