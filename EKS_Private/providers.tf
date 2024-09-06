terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}



provider "aws" {
  region = "eu-west-2"
  # profile = "${AWS_PROFILE}"
  profile = "alexm2"
  default_tags {
    tags = {
      Project   = "Alex_Test"
      Contact   = "alex.mavrogiannis"
      Terraform = "TRUE"
    }
  }
}

# variable "AWS_PROFILE" {}
