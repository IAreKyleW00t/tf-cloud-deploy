##
# General
##
variable "tags" {
  type        = map(string)
  description = "Additional tags to include with all resources"
  default     = {}
}

##
# Cloudflare
##
variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_zone" {
  type        = string
  description = "Cloudflare Zone to perform DNS operations in"
}

##
# SSH
##
variable "ssh_key" {
  type        = string
  description = "Public SSH key to use for Netmaker EC2 instance"
  default     = "" # No SSH access
}

variable "ssh_allowed_ips" {
  type        = list(string)
  description = "List of IPs (CIDR notation) to allow SSH traffic from"
  default     = []
}

##
# VPC
##
variable "vpc_name" {
  type        = string
  description = "VPC name (and prefix for related resources)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR range for VPC"
}

variable "vpc_azs" {
  type        = list(string)
  description = "List of availability zones to use for the VPC"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDR ranges - Must match the same number of AZs"
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDR ranges - Must match the same number of AZs"
}

##
# Alarms
##
variable "billing_alarm_threshold" {
  type        = string
  description = "Value in USD that must be met for alert to be triggered"
  default     = "20"
}
variable "billing_alarm_email" {
  type        = string
  description = "Email to be added to billing SNS topic for alerting"
}

##
# CDN
##
variable "cdn_domain" {
  type        = string
  description = "Public domain (and S3 bucket) for CDN through CloudFront"
}

variable "cloudfront_minimum_tls_protocol_version" {
  type        = string
  description = "Minimum TLS protocol version that should be allowed by clients"
  default     = "TLSv1.2_2021"
}

variable "cloudfront_certificate_key_algorithm" {
  type        = string
  description = "Key algorithm to use for ACM certificate"
  default     = "EC_prime256v1"
}

##
# EC2 settings
##
variable "ec2_ami" {
  type = object({
    arm64 = string
    amd64 = string
  })
  description = "AMI to use for EC2 instances (defaults to latest Ubuntu 22.04)"
  default     = { arm64 = "", amd64 = "" }
}

##
# Netmaker
##
variable "netmaker_eip_tag" {
  type        = string
  description = "Value of the Name tag for the Netmaker Elastic IP"
  default     = "netmaker"
}

variable "netmaker_access_key" {
  type        = string
  description = "Access Key for connecting to Netmaker server"
}

variable "additional_netclient_ips" {
  type        = list(string)
  description = "List of additional Netclient IPs (in CIDR notation) to allow direct WireGuard traffic from"
}

##
# DNS
##
variable "ingress_domain" {
  type        = string
  description = "Domain to point ingress IP to"
}

variable "additional_domains" {
  type = map(object({
    proxied = bool
  }))
  description = "List of additional domains to CNAME to ingress_domain"
}
