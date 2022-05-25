variable "aws-region" {
  type    = string
  default = "us-east-1"
}

variable "aws-profile" {
  type    = string
  default = "ACG"
}

variable "aws-ec2-owners" {
  type    = string
  default = "amazon"
}

variable "ec2-instance-name" {
  type    = string
  default = "Name"

}

variable "volume-avail-zone" {
  type    = string
  default = "us-east-1a"
}

variable "volume-size" {
  type    = number
  default = "60"
}