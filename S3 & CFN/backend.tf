provider "aws" {
  region  = "eu-west-1" #Select the region that you want to deploy the resources. 
  profile = "alexm"
}
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "alexm-us"
}


terraform {
  backend "s3" {
    bucket  = "tfstate-cv-prod"
    encrypt = true
    key     = "foo/terraform.tfstate"
    region  = "eu-west-1"
    profile = "alexm"
  }
}