# Reference: # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table
#Creating NAT and EIP to connect the resource to the internet. 
resource "aws_eip" "eip" {
  vpc = true
}

#Reference: # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public_subnet.id

  tags = {
    "Name" = "nat_gw"
  }
}

resource "aws_main_route_table_association" "nat_rta" {
  vpc_id = aws_vpc.myvpc.id
  route_table_id = aws_default_route_table.main.id

}