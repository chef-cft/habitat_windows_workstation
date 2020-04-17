output "vpc_id" {
<<<<<<< HEAD
  value = aws_vpc.habworkshop-vpc.id
}

output "subnet_id" {
  value = aws_subnet.habworkshop-subnet.id
}

output "workstation_public_ips" {
  value = [aws_instance.workstation.*.public_ip]
}

=======
  value = "${aws_vpc.habworkshop-vpc.id}"
}

output "subnet_id" {
  value = "${aws_subnet.habworkshop-subnet.id}"
}

output "workstation_public_ips" {
  value = ["${aws_instance.workstation.*.public_ip}"]
}
>>>>>>> 49e2a47f1909784e8c6547bad266f39e3a886c1d
