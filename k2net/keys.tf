##
# SSH Keys
##
resource "aws_key_pair" "ssh" {
  count = var.ssh_key != "" ? 1 : 0

  key_name   = "${var.vpc_name}-key"
  public_key = var.ssh_key
  tags       = local.tags
}
