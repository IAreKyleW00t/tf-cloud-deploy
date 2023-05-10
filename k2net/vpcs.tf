##
# VPCs
##
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  enable_ipv6            = true
  create_egress_only_igw = false # don't let IPv6 traffic leak out of private subnets

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  tags = local.tags
}
