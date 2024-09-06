# AWS VPC - set to enable in order to build ONE.
resource "aws_vpc" "this" {
  count                = var.create_vpc ? 1 : 0
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.vpc_name}"
  }
}

# Output VPC ID to make use to a different module.
output "aws_vpc_id" {
  # value = [for vpc in aws_vpc.this : vpc.id if var.enable]
  value = aws_vpc.this[0].id
}

# Setting default SG for VPC
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this[0].id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = {
    Name = "${var.vpc_name}-default_sg"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this[0].id

  tags = {
    Name = "alexm-test-igw"
  }
}

// EIP 
/*
resource "aws_eip" "this" {
  count  = length(data.aws_availability_zones.available.names)
  domain = "vpc"

  tags = {
    Name = "alexm-test-eip-${data.aws_availability_zones.available.names[count.index]}"
  }

  depends_on = [aws_internet_gateway.this]
}
*/

# Public Route table - for all public subs
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.this[0].id

  route {
    cidr_block = var.cidr_block_public_route
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "${var.vpc_name}-public-rt-table"
    Type = "Public"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.rt_public.id
}

# Private Route table - each private sub has it's own RT. 
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.this[0].id
  count  = length(data.aws_availability_zones.available.names)

  tags = {
    Name = "${var.vpc_name}-private-rt-table-${data.aws_availability_zones.available.names[count.index]}"
    Type = "Private"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.rt_private[count.index].id
}

# AZ data
data "aws_availability_zones" "available" {}

# Building public subnet in each AZ.
resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = cidrsubnet(var.public_sub_cidr_block, 8, count.index + 100)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = var.allow_public_ip
  tags = merge(
    {
      Name = "${var.vpc_name}-vpc-public-sub-${count.index + 1}"
      Type = "Public"
    },
    var.public_subnet_tags
  )
}

# Output public sub for other module to use. 
output "public_subnet_id" {
  value = [for subnet in aws_subnet.public_subnet : subnet.id]
}

# Building private subnet in each AZ.
resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.this[0].id
  cidr_block              = cidrsubnet(var.private_sub_cidr_block, 8, count.index + 120)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = merge(
    {
      Name = "${var.vpc_name}-vpc-private-sub-${count.index + 1}"
      Type = "Private"
    },
    var.private_subnet_tags
  )
}

# Output private sub for other module to use. 
output "private_subnet_id" {
  value = [for subnet in aws_subnet.private_subnet : subnet.id]
}

#####################################
// Build the END POINT here 
#####################################