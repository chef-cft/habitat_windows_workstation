provider "aws" {
  region                  = "${var.aws_region}"
  profile                 = "${var.aws_profile}"
  shared_credentials_file = "~/.aws/credentials"
}
resource "random_id" "instance_id" {
  byte_length = 4
}

////////////////////////////////
// Instance Data

data "aws_ami" "windows_workstation" {
  most_recent = true

  filter {
    name   = "name"
    values = ["windows_2016_habitat_workstation_*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["496323866215"]
}

////////////////////////////////
// VPC

resource "aws_vpc" "habworkshop-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name          = "${var.tag_contact}-${var.tag_name}-vpc"
    X-Dept        = "${var.tag_dept}"
    X-Customer    = "${var.tag_customer}"
    X-Project     = "${var.tag_project}"
    X-Contact     = "${var.tag_contact}"
    X-Application = "${var.tag_application}"
    X-TTL         = "${var.tag_ttl}"
  }
}

resource "aws_internet_gateway" "habworkshop-gateway" {
  vpc_id = "${aws_vpc.habworkshop-vpc.id}"

  tags {
    Name = "${var.tag_contact}-${var.tag_name}-gateway"
  }
}

resource "aws_route" "habworkshop-internet-access" {
  route_table_id         = "${aws_vpc.habworkshop-vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.habworkshop-gateway.id}"
}

resource "aws_subnet" "habworkshop-subnet" {
  vpc_id                  = "${aws_vpc.habworkshop-vpc.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.tag_contact}-${var.tag_name}-subnet"
  }
}