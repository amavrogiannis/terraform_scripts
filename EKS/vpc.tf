module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"
  # insert the 23 required variables here

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c", "${var.region}d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]

  manage_default_network_acl = true
  default_network_acl_tags   = { Name = "${var.vpc_name}-default" }

  manage_default_route_table = true
  default_route_table_tags   = { Name = "${var.vpc_name}-default" }

  manage_default_security_group = true
  default_security_group_ingress = [{
    description = "public access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }]
  default_security_group_egress = [{
    description      = "public outgoing"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
    ipv6_cidr_blocks = "::/0"
  }]
  default_security_group_tags = { Name = "${var.vpc_name}-default" }

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6 = false

  enable_nat_gateway = true
  enable_vpn_gateway = true

  single_nat_gateway  = false
  reuse_nat_ips       = true
  external_nat_ip_ids = aws_eip.nat.*.id

  public_subnet_tags = {
    name = "${var.vpc_name}.public"
  }
  private_subnet_tags = {
    name = "${var.vpc_name}.private"
  }

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
}

resource "aws_eip" "nat" {
  count = 4
  vpc   = true
}

output "vpc" {
  value = module.vpc.name
}