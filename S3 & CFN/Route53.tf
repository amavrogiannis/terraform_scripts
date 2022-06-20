resource "aws_route53_zone" "alexmavcouk" {
  name = var.domain_name
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "sub_domain_record" {
  name    = var.bucket_id
  type    = var.dns_record_type
  zone_id = aws_route53_zone.alexmavcouk.zone_id
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }


  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_route53_record" "cert_record" {
  # for_each = {
  #   for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
  #     name   = dvo.resource_record_name
  #     record = dvo.resource_record_value
  #     type   = dvo.resource_record_type
  #   }
  # }

  # allow_overwrite = true
  # name            = each.value.name
  # records         = [each.value.record]
  # ttl             = 60
  # type            = each.value.type
  # zone_id         = aws_route53_zone.alexmavcouk.zone_id
  count = length(aws_acm_certificate.cert.domain_validation_options)
  name = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)
  type = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)
  zone_id = aws_route53_zone.alexmavcouk.zone_id
  records = [ element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index) ]
  ttl = var.dns_record_ttl


  lifecycle {
    prevent_destroy = true
  }
}