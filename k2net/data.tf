##
# General
##
data "aws_caller_identity" "current" {}
data "aws_iam_account_alias" "current" {}
data "aws_region" "current" {}

##
# Cloudflare Zones
##
data "cloudflare_zone" "dns" {
  name = var.cloudflare_zone
}

##
# AMIs
##
data "aws_ami" "ubuntu-arm64" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu-amd64" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##
# Elastic IPs
##
data "aws_eip" "netmaker" {
  tags = {
    Name = var.netmaker_eip_tag
  }
}

##
# Default Security Groups
##
data "aws_security_group" "default" {
  name       = "default"
  vpc_id     = module.vpc.vpc_id
  depends_on = [module.vpc]
}
