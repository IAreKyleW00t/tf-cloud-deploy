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
# Netmaker
##
variable "netmaker_domain" {
  type        = string
  description = "Base domain for Netmaker server"
}

variable "netmaker_allowed_ips" {
  type        = list(string)
  description = "List of IPs (CIDR notation) to allow Netmaker traffic from"
  default     = ["0.0.0.0/0"]
}

variable "netmaker_ports" {
  type        = string
  description = "Range of ports for Wireguard, in 'start-end' format"
  default     = "51821-51830"

  validation {
    condition     = can(regex("^\\d+-\\d+$", var.netmaker_ports))
    error_message = "Err: Netmaker ports must be two valid numbers in the format 'start-end'"
  }
}
