output "vpc_id" {
  value = "${aws_vpc.habworkshop-vpc.id}"
}

output "subnet_id" {
  value = "${aws_subnet.habworkshop-subnet.id}"
}