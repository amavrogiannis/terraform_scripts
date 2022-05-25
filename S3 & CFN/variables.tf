variable "bucket_id" {
  description = "Give a name to the S3 Bucket"
  type        = string
  default     = "cv.alexmav.co.uk"
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

variable "acm_certificate_arn" {
  description = "Paste the ARN Certificate you created on AWS ACM"
  type        = string
  default     = "arn:aws:acm:us-east-1:582037776064:certificate/44b3e5f4-b8d1-4a3d-b585-2f00733a53f4"
}

variable "aws_cfn_comment" {
  description = "Enter your CloudFront comment here"
  type        = string
  default     = "Personal deployment"
}

