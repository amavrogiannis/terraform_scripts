
data "aws_acm_certificate" "issued" {
  domain   = var.bucket_id
  statuses = ["ISSUED"]
  provider = aws.virginia
}