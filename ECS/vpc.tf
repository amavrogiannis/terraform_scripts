resource "aws_vpc" "this" {
  cidr_block = "10.20.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    "Name" = "this-vpc"
  }
}

resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.20.2${count.index}.0/26"

  tags = {
    "Name" = "this-private-${count.index}"
  }
}

resource "aws_subnet" "public" {
  count      = 2
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.20.3${count.index}.0/26"

  tags = {
    "Name" = "this-public-${count.index}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = "this-igw"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    "Name" = "this-route-table"
  }
}

resource "aws_route_table_association" "this" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.this.id
}

resource "aws_security_group" "this-ecs" {
  name   = "this-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
  }

  egress {
    description = "Out any"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}