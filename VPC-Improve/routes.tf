resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.myvpc.default_route_table_id
  route {
      cidr_block = var.vpc-route-table
      nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    "Name" = "route_table"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# Creating public route table and associating subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.myvpc.id
    route = [{
        carrier_gateway_id = null
        cidr_block = var.vpc-route-table
        destination_prefix_list_id = null
        egress_only_gateway_id = null
        gateway_id = "${aws_internet_gateway.igw.id}"
        instance_id = null
        ipv6_cidr_block = null
        local_gateway_id = null
        nat_gateway_id = null 
        network_interface_id = null
        transit_gateway_id = null
        vpc_endpoint_id = null
        vpc_peering_connection_id = null
    }]

    tags = {
        Name = "public"
    }
  
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}