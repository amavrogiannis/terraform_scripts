terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "~> 1.3"
}

provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      Project   = "Alex_Test"
      Contact   = "alex.mavrogiannis"
      Terraform = "TRUE"
    }
  }
}