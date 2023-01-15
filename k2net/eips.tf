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

resource "aws_eip" "padparadscha" {
  instance                  = aws_instance.padparadscha.id
  associate_with_private_ip = aws_instance.padparadscha.private_ip

  tags = merge(local.tags, {
    Name = "padparadscha"
  })
}

resource "aws_eip" "fluorite" {
  instance                  = aws_instance.fluorite.id
  associate_with_private_ip = aws_instance.fluorite.private_ip

  tags = merge(local.tags, {
    Name = "fluorite"
  })
}
