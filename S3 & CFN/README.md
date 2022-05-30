The terraform in this directory is structured with workspaces: 
* default
* testing

The tfstate file is also enabled to an S3 bucket. 

To apply the configuration in each workspace is: 
* default - terraform plan -var-file default.tfvars
* testing - terraform plan -var-file testing.tfvars