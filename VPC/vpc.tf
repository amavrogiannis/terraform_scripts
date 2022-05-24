resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.104.0.0/16" #"${var.vpc_subnet}"
  enable_dns_support   = "true" #This gives you internal domain name
  enable_dns_hostnames = "true" #This gives you internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"
  tags = merge (
      { Name = var.resource_tags },
      var.resource_tags
  )

}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.dev-vpc.id
  cidr_block              = var.vpc_public_subnet
  availability_zone       = var.vpc_subnet_az
  map_public_ip_on_launch = true
  tags = var.resource_tags
}

