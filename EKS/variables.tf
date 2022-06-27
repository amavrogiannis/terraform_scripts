variable "vpc_name" {
  default = "alexm-vpc"
}

variable "region" {
  default = "us-east-1"
}

variable "iam_user" {
  default = "cloud_user"
}

variable "eks_cluster_name" {
  default = "alexm-eks"
}

variable "auto_scaling_group" {
  default = "alexm-AG-lab"
}

variable "AG_max_size" {
  default = 2
}

variable "AG_min_size" {
  default = 1
}
variable "instance_type" {
  default = "t3.small"
}