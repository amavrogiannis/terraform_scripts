create_vpc = true
vpc_name   = "alex-test"

vpc_cidr = "10.0.0.0/16"

enable_dns_hostnames = true
enable_dns_support   = true

enable_network_address_usage_metrics = false

default_security_group_ingress = [{
  self        = true
  description = "inbound from VPC"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
}]
default_security_group_egress = [{
  cidr_blocks = "0.0.0.0/0"
  description = "outbound anywhere"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
}]

cidr_block_public_route = "0.0.0.0/0"

allow_public_ip = true

public_sub_cidr_block  = "10.0.20.0/16"
private_sub_cidr_block = "10.0.30.0/16"

private_subnet_tags = {
  "kubernetes.io/role/internal-elb" = 1,
  "kubernetes.io/cluster/alex-eks"  = "owned"
}