variable "region" {
  description = "AWS region to create the resource in"
  type = string
}

variable "domain_name" {
  description = "Domain name for the CloudFront distribution"
  type        = string
}