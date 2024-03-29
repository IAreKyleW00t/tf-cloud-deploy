##
# EC2 Instances
##
resource "aws_instance" "topaz" {
  instance_type = "t4g.small"
  ami           = var.ec2_ami.arm64 != "" ? var.ec2_ami.arm64 : data.aws_ami.ubuntu-arm64.id
  key_name      = local.ec2_ssh_key

  iam_instance_profile = aws_iam_instance_profile.ec2_read_netmaker_secret.name
  user_data            = data.template_file.userdata_netclient.rendered

  associate_public_ip_address = true
  availability_zone           = module.vpc.azs[0]
  subnet_id                   = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.netclient.id,
    aws_security_group.netclient_public.id,
    aws_security_group.unifi.id,
    aws_security_group.web.id,
    aws_security_group.ssh.id
  ]

  root_block_device {
    encrypted   = true
    volume_size = 16 # GB
    volume_type = "gp3"
    tags = merge(local.tags, {
      Name = "topaz"
    })
  }

  tags = merge(local.tags, {
    Name   = "topaz",
    Public = "true"
  })
}

resource "aws_instance" "padparadscha" {
  instance_type = "t4g.micro"
  ami           = var.ec2_ami.arm64 != "" ? var.ec2_ami.arm64 : data.aws_ami.ubuntu-arm64.id
  key_name      = local.ec2_ssh_key

  iam_instance_profile = aws_iam_instance_profile.ec2_read_netmaker_secret.name
  user_data            = data.template_file.userdata_netclient.rendered

  associate_public_ip_address = true
  availability_zone           = module.vpc.azs[0]
  subnet_id                   = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.netclient.id,
    aws_security_group.ssh.id
  ]

  root_block_device {
    encrypted   = true
    volume_size = 16 # GB
    volume_type = "gp3"
    tags = merge(local.tags, {
      Name = "padparadscha"
    })
  }

  tags = merge(local.tags, {
    Name = "padparadscha"
  })
}

resource "aws_instance" "pihole" {
  instance_type = "t4g.nano"
  ami           = var.ec2_ami.arm64 != "" ? var.ec2_ami.arm64 : data.aws_ami.ubuntu-arm64.id
  key_name      = local.ec2_ssh_key

  iam_instance_profile = aws_iam_instance_profile.ec2_read_netmaker_secret.name
  user_data            = data.template_file.userdata_netclient.rendered

  associate_public_ip_address = true
  availability_zone           = module.vpc.azs[0]
  subnet_id                   = module.vpc.public_subnets[0]

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.netclient.id,
    aws_security_group.ssh.id
  ]

  root_block_device {
    encrypted   = true
    volume_size = 16 # GB
    volume_type = "gp3"
    tags = merge(local.tags, {
      Name     = "pihole-2",
      Snapshot = "${var.vpc_name}/true" # Pi-Hole is installed on main volume
    })
  }

  tags = merge(local.tags, {
    Name = "pihole-2"
  })
}
