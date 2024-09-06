variable "vpc_name" {
  type        = string
  description = "Name your VPC"
}

variable "create_vpc" {
  type    = bool
  default = false
}

variable "vpc_cidr" {
  type        = string
  description = "Provide the VPC IP Address"
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "enable_network_address_usage_metrics" {
  type = bool
}

variable "default_security_group_ingress" {

}

variable "default_security_group_egress" {

}

variable "cidr_block_public_route" {
  type    = string
  default = "0.0.0.0/0"
}

variable "allow_public_ip" {
  type = bool
}

variable "public_sub_cidr_block" {
  type = string
}

variable "private_sub_cidr_block" {
  type = string
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}