# Resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

# Create a 2 subnets

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "${var.my-vpc-public-subnet}"
  map_public_ip_on_launch = true
  availability_zone = "${var.my-vpc-public-subnet-availzone}"

  tags = {
    "Name" = "public_subnet_1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.my-vpc-private-subnet
  map_public_ip_on_launch = false
  availability_zone = "${var.my-vpc-private-subnet-availzone}"

  tags = {
    "Name" = "private_subnet_1"
  }
}