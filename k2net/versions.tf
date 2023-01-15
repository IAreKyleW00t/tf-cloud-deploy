terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }

  # Configured in terraform.tfbackend
  backend "s3" {
  }

  required_version = "~> 1.3"
}
