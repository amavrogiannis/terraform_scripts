variable "bucket_id" {
  description = "Give a name to the S3 Bucket"
  type        = string
}

variable "bucket_env_tag" {
  description = "Specify one of the tags >> [dev/qa/uat/prod]"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "uat", "prod"], var.bucket_env_tag)
    error_message = "You have to only specify one of the following >> dev/qa/uat/prod"
  }
}

variable "bucket_group_tag" {
  description = "Specify your tags [cv/test/www]"
  type        = string
  validation {
    condition     = contains(["cv", "test", "www"], var.bucket_group_tag)
    error_message = "You have to only specify one of the following >> cv/test/www"
  }
}

# variable "acm_certificate_arn" {
#   description = "Paste the ARN Certificate you created on AWS ACM"
#   type        = string
# }

variable "aws_cfn_comment" {
  description = "Enter your CloudFront comment here"
  type        = string
  default     = "Personal deployment"
}

