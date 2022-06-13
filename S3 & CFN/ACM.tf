resource "aws_acm_certificate" "cert" {
  domain_name       = var.bucket_id
  validation_method = var.domain_method

  tags = {
    Environment = "${var.bucket_env_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
  provider = aws.virginia
}

resource "aws_acm_certificate_validation" "cert_val" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
  provider                = aws.virginia
}