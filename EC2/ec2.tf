terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  region                    = "us-east-1"
  profile                   = "ACloudGuru"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-01dcf0d6f7084c990"]
  subnet_id = "subnet-0775d25cac9ab9e72"

  tags = {
    Name = "EC2Deploy-EC2"
  }
}