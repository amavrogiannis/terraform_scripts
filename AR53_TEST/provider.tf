terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3"
}

provider "aws" {
  region  = "eu-west-1"
  profile = "alexm"
  default_tags {
    tags = {
      Contact = "alex.mavrogiannis"
      Project = "Personal test"
    }
  }
}