output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.bucket_name.id
}

output "ssl_cert" {
  value = aws_acm_certificate.cert.arn
}

