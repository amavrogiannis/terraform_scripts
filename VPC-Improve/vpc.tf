#Create a VPC to launch resources
resource "aws_vpc" "myvpc" {
  cidr_block = var.my-vpc-cidr-block

  tags = {
    "Name" = "test"
  }
}

#Create an Internet Gateway (IGW) to give subnet access to the Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
      "Name" = "test"
  }
}