resource "aws_vpc" "dev-vpc" {
  cidr_block           = var.dev-vpc-cidr #"${var.vpc_subnet}"
  enable_dns_support   = "true"           #This gives you internal domain name
  enable_dns_hostnames = "true"           #This gives you internal host name
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

