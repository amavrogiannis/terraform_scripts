variable "domain_name" {
  type    = string
  default = "alexmav.co.uk"
}

variable "subdomain_name" {
  type    = string
  default = "sample.alexmav.co.uk"
}

variable "dns_record_type" {
  type    = string
  default = "A"
}

variable "dns_record_ttl" {
  type    = string
  default = "300"
}

variable "dns_record_alias" {
  type    = string
  default = "0.0.0.0"
}

variable "domain_method" {
  type    = string
  default = "DNS"
}

variable "env_tag" {
  type    = string
  default = "Sample"
}
