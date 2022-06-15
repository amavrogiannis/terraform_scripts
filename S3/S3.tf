resource "aws_s3_bucket" "s3_backend" {
  bucket = var.bucket_id
  tags = {
    Group = var.bucket_group_tag
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.s3_backend.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_backend" {
  bucket = aws_s3_bucket.s3_backend.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_backend" {
  bucket = aws_s3_bucket.s3_backend.id

  //block_public_acls       = true
  //block_public_policy     = true
  //ignore_public_acls      = true
  //restrict_public_buckets = true
}