resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

resource "aws_route53_record" "sub_domain" {
  name    = var.subdomain_name
  ttl     = var.dns_record_ttl
  type    = var.dns_record_type
  zone_id = aws_route53_zone.primary.zone_id
  records = [
    var.dns_record_alias
  ]


  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.subdomain_name
  validation_method = var.domain_method
#   validation_option {
#     domain_name       = "${var.subdomain_name}"
#     validation_domain = "${var.domaon_name}"
#   }

  tags = {
    Environment = "${var.env_tag}"
  }

  lifecycle {
    create_before_destroy = true
  }
  # provider = aws.virginia
}


resource "aws_route53_record" "cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}


resource "aws_acm_certificate_validation" "cert_val" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_record : record.fqdn]
  # provider = aws.virginia
}