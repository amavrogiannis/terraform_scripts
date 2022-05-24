
variable "dev-vpc-cidr" {
  default = "10.20.0.0/24"
}

variable "vpc-public-subnet" {
  description = "enter the public subnet IP address"
  type        = string
  default     = "10.21.0.0/24"
}

variable "vpc-private-subnet" {
  description = "enter the private subnet IP address"
  type        = string
  default     = "10.22.0.0/24"
}