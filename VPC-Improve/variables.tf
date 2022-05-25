variable "aws_region" {
  description = "Provide the AWS region you want to deploy your resources"
  type = string
  default = "us-east-1"
}

variable "aws_account_profile" {
    description = "Describe the profile you stored the AWS credentials for the deployment"
    type = string
    default = "ACG"
}

# Follow the standards: https://en.wikipedia.org/wiki/Classless_Inter-Domain_Routing
variable "my-vpc-cidr-block" {
  type = string
  default = "10.104.0.0/16"
}

variable "vpc-route-table" {
  type = string
  default = "0.0.0.0/0"
}

variable "my-vpc-public-subnet" {
  type = string
  default = "10.104.16.0/20"
}

variable "my-vpc-public-subnet-availzone" {
  type = string
  default = "us-east-1c"
}

variable "my-vpc-private-subnet" {
  type = string
  default = "10.104.0.0/20"
}

variable "my-vpc-private-subnet-availzone" {
  type = string
  default = "us-east-1a"
}