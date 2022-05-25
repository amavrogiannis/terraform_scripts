
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

variable "private-subnet-cidr-blocks" {
  description = "List of private subnet CIDR blocks"
  type        = list
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "vpc-public-cidr" {
  description = "cidr block that is mapping to PublicRT"
  type = string
  default = "value"
}