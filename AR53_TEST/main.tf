variable "acm_certificates" {
  type    = map(object({
    domain_name       = string
    validation_method = string
  }))
  description = "Map of ACM certificates with domain names and validation methods."
  default = {
    "nameme" = {
      domain_name = "nameme.alexmav.co.uk"
      validation_method = "DNS"
    }
    "shou" = {
      domain_name = "shou.alexmav.co.uk"
      validation_method = "DNS"
    }
  }
}


data "aws_route53_zone" "personal_one" {
  name = "alexmav.co.uk"
}


resource "aws_acm_certificate" "acm_certificates" {
  for_each = var.acm_certificates

  domain_name       = each.value.domain_name
  validation_method = each.value.validation_method

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "acm_certificates" {
  for_each = var.acm_certificates
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.acm_certificates[each.key].domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.acm_certificates[each.key].domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.acm_certificates[each.key].domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.personal_one.zone_id
  ttl = 60
}

resource "aws_acm_certificate_validation" "name" {
  for_each = var.acm_certificates
  certificate_arn = aws_acm_certificate.acm_certificates[each.key].arn
  validation_record_fqdns = [aws_route53_record.acm_certificates[each.key].fqdn]
}

# ========

variable "domain_names_this" {
  type = map(object({
    name = string
    sub_value = string
    r53_record_type = string
    r53_record_ttl = number
    target_record = list(string)
    ssl_domain_name = string
  }))

  default = {
    nameme = {
        name = "nameme.alexmav.co.uk"
        sub_value = "nameme"
        r53_record_type = "CNAME"
        r53_record_ttl = 300
        target_record = ["dnbuxrum3jpxr.cloudfront.net."]
        ssl_domain_name = "nameme.alexmav.co.uk"
    }
    shou = {
        name = "shou.alexmav.co.uk"
        sub_value = "shou"
        r53_record_type = "CNAME"
        r53_record_ttl = 300
        target_record = ["dnbuxrum3jpxr.cloudfront.net."]
        ssl_domain_name = "shou.alexmav.co.uk"
    }
  }
}

resource "aws_route53_record" "this1" {
  for_each = var.domain_names_this
  zone_id = data.aws_route53_zone.personal_one.zone_id

  name = each.key
  type = each.value.r53_record_type
  ttl = each.value.r53_record_ttl
  records = each.value.target_record
}

output "certificate_arn" {
  value = {
    for k, cert in aws_acm_certificate.acm_certificates : k => cert.arn
  }
}