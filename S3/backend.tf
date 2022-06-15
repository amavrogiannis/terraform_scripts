provider "aws" {
  region  = "eu-west-1" #Select the region that you want to deploy the resources. 
  profile = "alexm"
}



# terraform {
#   backend "s3" {
#     bucket  = "tfstate-ecs"
#     encrypt = true
#     key     = "foo/terraform.tfstate"
#     region  = "eu-west-1"
#     profile = "alexm"
#   }
# }