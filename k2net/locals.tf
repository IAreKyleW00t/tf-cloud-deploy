locals {
  aws_account_id    = data.aws_caller_identity.current.account_id
  aws_account_alias = data.aws_iam_account_alias.current.account_alias
  aws_region        = data.aws_region.current.name

  ec2_ssh_key = var.ssh_key != "" ? "${var.vpc_name}-key" : ""

  s3_origin_id = "s3-${aws_s3_bucket.cdn.id}"

  # Global tags
  tags = merge(var.tags, {
    Terraform = "true",
    VPC       = var.vpc_name
  })
}
