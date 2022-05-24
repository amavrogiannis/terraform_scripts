#Internet Gateway for the VPC
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

#Private subnet
resource "aws_subnet" "vpc-public-sub" {
  vpc_id     = aws_vpc.dev-vpc
  cidr_block = var.vpc-public-subnet
}

#Public subnet
resource "aws_subnet" "vpc-private-sub" {
  vpc_id     = aws_vpc.dev-vpc
  cidr_block = var.vpc-private-subnet

}



#Custom Route Table for the VPC - Public
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.dev-vpc.id
  route = {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
}

#Custom Route Table for the VPC - Private
resource "aws_route_table" "PrivateRT" {
  vpc_id = aws_vpc.dev-vpc.id
  route = {
    # carrier_gateway_id = "value"
    cidr_block = "0.0.0.0/0"
    # destination_prefix_list_id = "value"
    # egress_only_gateway_id = "value"
    # gateway_id = "value"
    # instance_id = "value"
    # ipv6_cidr_block = "value"
    # local_gateway_id = "value"
    nat_gateway_id = aws_nat_gateway.natGW.id
    # network_interface_id = "value"
    # transit_gateway_id = "value"
    # vpc_endpoint_id = "value"
    # vpc_peering_connection_id = "value"
  }
}

#Route Table associates on subnets - Public
resource "aws_route_table_association" "PublicRT-Assoc" {
  subnet_id      = aws_subnet.vpc-public-sub.id
  route_table_id = aws_route_table.PublicRT.id
}

#Route Table associates on subnets - Private

resource "aws_route_table_association" "PrivateRT-Assoc" {
  subnet_id      = aws_subnet.vpc-private-sub.id
  route_table_id = aws_route_table.PrivateRT.id
}

resource "aws_eip" "nateIP" {
  vpc = true
}

#Creating NAT Gateway using subnet_id and allocation_id
resource "aws_nat_gateway" "natGW" {
  allocation_id = aws_eip.nateIP.id
  subnet_id     = aws_subnet.vpc-public-sub.id
}