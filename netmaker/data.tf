##
# Cloudflare Zones
##
data "cloudflare_zone" "netmaker" {
  name = var.cloudflare_zone
}

##
# Default Security Groups
##
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.netmaker_vpc.vpc_id
}

##
# AMIs
##
data "aws_ami" "amzn2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-minimal-hvm-*-arm64-ebs"]
  }
}

data "aws_ami" "ubuntu" {
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
