output "subnet_publicid" {
  value = aws_subnet.public_subnet.id
}

output "subnet_privateid" {
  value = aws_subnet.private_subnet.id
}

output "vpcid" {
  value = aws_vpc.myvpc.id
}