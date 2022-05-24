#Internet Gateway for the VPC
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = var.resource_tags
}

#Custom Route Table for the VPC
resource "aws_route_table" "dev-crt-public" {
  route = [{
    #carrier_gateway_id = "value"
    cidr_block = "0.0.0.0/0"
    #destination_prefix_list_id = "value"
    #egress_only_gateway_id = "value"
    gateway_id = aws_internet_gateway.vpc-igw.id
    #instance_id = "value"
    #ipv6_cidr_block = "value"
    #local_gateway_id = "value"
    #nat_gateway_id = "value"
    #network_interface_id = "value"
    #transit_gateway_id = "value"
    #vpc_endpoint_id = "value"
    #vpc_peering_connection_id = "value"
  }]
}

resource "aws_route_table_association" "dev-crta-public-sub" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.dev-crt-public.id

}