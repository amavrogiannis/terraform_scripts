provider "aws" {
  region  = var.aws_region #Select the region that you want to deploy the resources. 
  profile = var.aws_account_profile
}
