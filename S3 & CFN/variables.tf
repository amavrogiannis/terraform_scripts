variable "bucket_id" {
  description = "Give a name to the S3 Bucket"
  type        = string
  default     = "test.alexmav.co.uk"
}

variable "bucket_env_tag" {
    description = "Specify one of the tags >> [dev/qa/uat/prod]"
    type = string
    validation {
      condition = contains(["dev", "qa", "uat", "prod"], var.bucket_env_tag)
      error_message = "You have to only specify one of the following >> dev/qa/uat/prod"
    }
}

variable "bucket_group_tag" {
    description = "Specify your tags [cv/test/www]"
    type = string
    default = "wwww"
}

variable "acm_certificate_arn" {
    description = "Paste the ARN Certificate you created on AWS ACM"
    type = string
  default = "arn:aws:acm:us-east-1:582037776064:certificate/1bb0bf47-9c2c-4030-9b17-5a6d3d317a93"
}

variable "aws_cfn_comment" {
  description = "Enter your CloudFront comment here"
  type = string
  default = "N/A"
}

