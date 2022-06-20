locals {
  instance_name = "${terraform.workspace}-bucket"
}

resource "aws_s3_bucket" "bucket_name" {
  bucket = var.bucket_id
  tags = {
    Environment = var.bucket_env_tag
    Group       = var.bucket_group_tag
  }
}

resource "aws_s3_bucket_website_configuration" "bucket_name" {
  bucket = aws_s3_bucket.bucket_name.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = 404
  }

}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.bucket_name.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_name" {
  bucket = aws_s3_bucket.bucket_name.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket_name.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_name" {
  bucket = aws_s3_bucket.bucket_name.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "bucket_name" {
  bucket = aws_s3_bucket.bucket_name.id

  //block_public_acls       = true
  //block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}