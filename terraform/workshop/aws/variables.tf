<<<<<<< HEAD
=======

>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d
////////////////////////////////
// AWS Connection

variable "aws_profile" {
  default = "default"
}
<<<<<<< HEAD

=======
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d
variable "aws_region" {
  default = "us-west-2"
}

variable "aws_instance_type" {
  default = "t3.large"
}

////////////////////////////////
// Tags

<<<<<<< HEAD
variable "tag_customer" {
}

variable "tag_project" {
}
=======
variable "tag_customer" {}

variable "tag_project" {}
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d

variable "tag_name" {
  default = "hab-win-ws"
}

<<<<<<< HEAD
variable "tag_dept" {
}

variable "tag_contact" {
}
=======
variable "tag_dept" {}

variable "tag_contact" {}
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d

variable "tag_application" {
  default = "hab-win-ws"
}

<<<<<<< HEAD
variable "tag_ttl" {
}

variable "aws_key_pair_file" {
}

variable "aws_key_pair_name" {
}
=======
variable "tag_ttl" {}

variable "aws_key_pair_file" {}

variable "aws_key_pair_name" {}
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d

////////////////////////////////
// Instance Configs

<<<<<<< HEAD
variable "workstations" {
  default = "1"
}

=======
variable "count" {
  default = "1"
}
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d
