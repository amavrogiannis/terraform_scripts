terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9" # You may have to update this at times. 
    }
  }

  required_version = ">= 0.12.31"
}

provider "aws" {
  profile = "default" #Specify your local AWS Profile that you specified here. 
  region  = "eu-west-1" #Select the region that you want to deploy the resources. 
}


resource "aws_s3_bucket" "mybucket" {
  bucket = "test.alexmav.co.uk"
  acl    = "private"
  # Add specefic S3 policy in the s3-policy.json on the same directory
  #policy = file("s3-policy.json")

  versioning {
    enabled = false
  }

  website {
    index_document = "index.html"
    error_document = "404.html"
	
	# Add routing rules if required
    #routing_rules = <<EOF
    #                [{
    #                    "Condition": {
    #                        "KeyPrefixEquals": "docs/"
    #                    },
    #                    "Redirect": {
    #                        "ReplaceKeyPrefixWith": "documents/"
    #                    }
    #                }]
    #                EOF
  }

# Specify your environment (tags)
  tags = {
    Environment = "WebApp"
    Name        = "Test"
  }

}


locals {
  s3_origin_id = "test.alexmav.co.uk"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "test.alexmav.co.uk"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.mybucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "This is a test version"
  default_root_object = "index.html"

  # Configure logging here if required 	
  #logging_config {
  #  include_cookies = false
  #  bucket          = "mylogs.s3.amazonaws.com"
  #  prefix          = "myprefix"
  #}

  # If you have domain configured use it here 
  aliases = ["test.alexmav.co.uk"]

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

    viewer_protocol_policy = "allow-all"
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
      restriction_type = "blacklist"
      locations        = ["RU"]
    }
  }

  tags = {
    Group = "webapp"
    Name = "Test"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# to get the Cloud front URL if doamin/alias is not configured
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.mybucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "mybucket" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = true
  block_public_policy     = true
  //ignore_public_acls      = true
  //restrict_public_buckets = true
}