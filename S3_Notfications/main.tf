variable "s3_bucket" {
  type = map(object({
    bucket_name             = string
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
    bucket_versioning       = string
    s3_notification = list(object({
      id = string
      lambda_arn    = string
      events        = list(string)
      filter_prefix = string
    }))
    sqs_queue = list(object({
      id            = string
      sqs_queue_arn = string
      events        = list(string)
      filter_prefix = string
    }))
    sns_topic = list(object({
      id            = string
      sns_topic_arn = string
      events        = list(string)
      filter_prefix = string
    }))
  }))
}

resource "aws_s3_bucket" "this" {
  for_each = var.s3_bucket

  bucket = each.value.bucket_name

}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = var.s3_bucket

  bucket = each.value.bucket_name

  block_public_acls       = each.value.block_public_acls
  block_public_policy     = each.value.block_public_policy
  ignore_public_acls      = each.value.ignore_public_acls
  restrict_public_buckets = each.value.restrict_public_buckets
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = var.s3_bucket

  bucket = each.value.bucket_name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  for_each = var.s3_bucket

  bucket = each.value.bucket_name
  versioning_configuration {
    status = each.value.bucket_versioning
  }
}

resource "aws_s3_bucket_notification" "this" {
  for_each = var.s3_bucket

  bucket = each.value.bucket_name

  dynamic "lambda_function" {
    for_each = each.value.s3_notification

    content {
      id = lambda_function.value.id
      lambda_function_arn = lambda_function.value.lambda_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
    }
  }

  dynamic "queue" {
    for_each = each.value.sqs_queue

    content {
      id            = queue.value.id
      queue_arn     = queue.value.sqs_queue_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
    }
  }

  dynamic "topic" {
    for_each = each.value.sns_topic

    content {
      id            = topic.value.id
      topic_arn     = queue.value.sns_topic_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
    }
  }
}