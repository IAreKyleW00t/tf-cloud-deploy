locals {
  ec2_ssh_key = var.ssh_key != "" ? "${var.vpc_name}-key" : ""

  # Global tags
  tags = merge(var.tags, {
    Terraform = "true"
    VPC       = var.vpc_name
  })
}
