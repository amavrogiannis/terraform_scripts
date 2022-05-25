resource "aws_vpc" "main" {
  cidr_block = "10.104.0.0/16"

  tags = {
    "Name" = "test"
  }

}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.104.16.0/20"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public_subnet_1"
  }
}