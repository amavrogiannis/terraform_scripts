output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.cv_prod.id
}

output "ssl_cert" {
  value = aws_acm_certificate.cert.arn
}

