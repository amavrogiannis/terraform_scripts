variable "bucket_id" {
  description = "Specify bucket name for the backend S3 bucket."
  type        = string
  default     = "tfstate-ecs"
}

variable "bucket_group_tag" {
  description = "Specify bucket tag for the backend S3 bucket."
  type        = string
  default     = "terraform"
}