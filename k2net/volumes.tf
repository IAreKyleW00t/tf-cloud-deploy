##
# EBS Volumes
##
resource "aws_ebs_volume" "unifi" {
  availability_zone = module.vpc.azs[0]
  size              = 5    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "unifi",
    Snapshot = "${var.vpc_name}/true"
  })
}

resource "aws_ebs_volume" "bitwarden" {
  availability_zone = module.vpc.azs[0]
  size              = 2    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "bitwarden",
    Snapshot = "${var.vpc_name}/true"
  })
}

resource "aws_ebs_volume" "heimdall" {
  availability_zone = module.vpc.azs[0]
  size              = 1    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "heimdall",
    Snapshot = "${var.vpc_name}/true"
  })
}

resource "aws_ebs_volume" "kuma" {
  availability_zone = module.vpc.azs[0]
  size              = 1    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "kuma",
    Snapshot = "${var.vpc_name}/true"
  })
}

resource "aws_ebs_volume" "znc" {
  availability_zone = module.vpc.azs[0]
  size              = 1    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "znc",
    Snapshot = "${var.vpc_name}/true"
  })
}

##
# Volume attachments
##
resource "aws_volume_attachment" "unifi" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.unifi.id
  instance_id = aws_instance.topaz.id
}

resource "aws_volume_attachment" "bitwarden" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.bitwarden.id
  instance_id = aws_instance.padparadscha.id
}

resource "aws_volume_attachment" "heimdall" {
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.heimdall.id
  instance_id = aws_instance.padparadscha.id
}

resource "aws_volume_attachment" "kuma" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.kuma.id
  instance_id = aws_instance.padparadscha.id
}

resource "aws_volume_attachment" "znc" {
  device_name = "/dev/sdi"
  volume_id   = aws_ebs_volume.znc.id
  instance_id = aws_instance.padparadscha.id
}
