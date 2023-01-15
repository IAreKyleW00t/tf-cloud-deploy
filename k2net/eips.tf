##
# Elastic IPs
##
resource "aws_eip" "topaz" {
  instance                  = aws_instance.topaz.id
  associate_with_private_ip = aws_instance.topaz.private_ip

  tags = merge(local.tags, {
    Name = "topaz"
  })
}
