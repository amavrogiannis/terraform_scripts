locals {
  instance_name = "${terraform.workspace}-bucket"
}

resource "aws_s3_bucket" "cv_prod" {
  bucket = var.bucket_id
  tags = {
    Environment = var.bucket_env_tag
    Group       = var.bucket_group_tag
  }
}

resource "aws_s3_bucket_website_configuration" "cv_prod" {
  bucket = aws_s3_bucket.cv_prod.id

  index_document {
    suffix = "index.html"
  }
  error_document {
    key = 404
  }

}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.cv_prod.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cv_prod" {
  bucket = aws_s3_bucket.cv_prod.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.cv_prod.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "cv_prod" {
  bucket = aws_s3_bucket.cv_prod.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "cv_prod" {
  bucket = aws_s3_bucket.cv_prod.id

  //block_public_acls       = true
  //block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}