terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.10" # You may have to update this at times. 
    }
  }

  required_version = ">= 0.12.31"
}

provider "aws" {
  profile = "default" #Specify your local AWS Profile that you specified here. 
  region  = "eu-west-1" #Select the region that you want to deploy the resources. 
}



resource "aws_s3_bucket" "b" {
  bucket = "cv.alexmav.co.uk"

  tags = {
    Environment = "WebApp"
    Name = "Test"
  }
}

resource "aws_s3_bucket_website_configuration" "b" {
  bucket = "cv.alexmav.co.uk"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "b" {
  bucket = aws_s3_bucket.b.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

locals {
  s3_origin_id = "cv.alexmav.co.uk"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cv.alexmav.co.uk"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.b.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Empty comment - AM"
  default_root_object = "index.html"

#  logging_config {
#    include_cookies = false
#    bucket          = "test.alexmav.co.uk"
#    prefix          = "logs/"
#  }

  aliases = ["cv.alexmav.co.uk"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none" #you can change it to whitelist/blacklist
      #locations        = ["RU"]
    }
  }

  tags = {
    Environment = "WebApp"
    Name = "Test"
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:582037776064:certificate/44b3e5f4-b8d1-4a3d-b585-2f00733a53f4"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }
}

# to get the Cloud front URL if doamin/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

#Bucket policy here
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.b.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.b.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "b" {
  bucket = aws_s3_bucket.b.id

  //block_public_acls       = true
  //block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}