
# data "aws_acm_certificate" "issued" {
#   domain   = var.bucket_id
#   statuses = ["ISSUED"]
#   provider = aws.virginia
# }

# data "aws_route53_zone" "alexmavcouk" {
#   name = "alexmav.co.uk"
#   private_zone = true
#   provider = aws.virginia
# }