terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }

  required_version = ">= 1.1"
}

