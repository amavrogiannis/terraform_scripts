provider "aws" {
  region  = "eu-west-1"
  profile = "alexm"
}

provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
  profile = "alexm-us"
}