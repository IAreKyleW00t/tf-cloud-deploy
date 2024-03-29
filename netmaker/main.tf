##
# SSH Keys
##
resource "aws_key_pair" "ssh" {
  count = var.ssh_key != "" ? 1 : 0

  key_name   = "${var.vpc_name}-key"
  public_key = var.ssh_key
  tags       = local.tags
}

##
# IAM Roles
##
resource "aws_iam_role" "dlm_lifecycle" {
  name               = "tf-${var.vpc_name}-ServiceRoleForDLM"
  assume_role_policy = file("../shared/policies/dlm-lifecycle-role-policy.json")

  tags = merge(local.tags, {
    Name = "tf-${var.vpc_name}-ServiceRoleForDLM"
  })
}

##
# IAM Policies
##
resource "aws_iam_role_policy" "dlm_lifecycle" {
  name   = "tf-${var.vpc_name}-dlm-lifecycle-policy"
  role   = aws_iam_role.dlm_lifecycle.id
  policy = file("../shared/policies/dlm-lifecycle-policy.json")
}

##
# Cloudflare DNS
##
resource "cloudflare_record" "netmaker4" {
  zone_id         = data.cloudflare_zone.netmaker.id
  name            = "*.${var.netmaker_domain}"
  value           = aws_eip.netmaker.public_ip
  type            = "A"
  allow_overwrite = true
}

resource "cloudflare_record" "netmaker6" {
  for_each = toset(aws_instance.netmaker.ipv6_addresses)

  zone_id         = data.cloudflare_zone.netmaker.id
  name            = "*.${var.netmaker_domain}"
  value           = each.key
  type            = "AAAA"
  allow_overwrite = true
}

##
# VPCs
##
module "netmaker_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  enable_ipv6            = true
  create_egress_only_igw = false # don't let IPv6 traffic leak out of private subnets

  azs                          = var.vpc_azs
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  private_subnet_ipv6_prefixes = var.vpc_private_ipv6_prefixes
  public_subnet_ipv6_prefixes  = var.vpc_public_ipv6_prefixes

  tags = local.tags
}

##
# Elastic IPs
##
resource "aws_eip" "netmaker" {
  instance                  = aws_instance.netmaker.id
  associate_with_private_ip = aws_instance.netmaker.private_ip

  tags = merge(local.tags, {
    Name = "netmaker"
  })
}

##
# EC2 Instances
##
resource "aws_instance" "netmaker" {
  instance_type = "t3.micro"
  ami           = var.ec2_ami != "" ? var.ec2_ami : data.aws_ami.ubuntu.id
  key_name      = local.ec2_ssh_key

  associate_public_ip_address = true
  availability_zone           = module.netmaker_vpc.azs[1]
  subnet_id                   = module.netmaker_vpc.public_subnets[1]

  vpc_security_group_ids = [
    data.aws_security_group.default.id,
    aws_security_group.netmaker.id,
    aws_security_group.ssh.id
  ]

  root_block_device {
    encrypted   = true
    volume_size = 16 # GB
    volume_type = "gp3"
    tags = merge(local.tags, {
      Name = "netmaker-1"
    })
  }

  tags = merge(local.tags, {
    Name   = "netmaker-1",
    Public = "true"
  })
}

##
# Security Groups
##
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allows SSH traffic from specific IPs"
  vpc_id      = module.netmaker_vpc.vpc_id
  tags = merge(local.tags, {
    Name = "ssh"
  })
}

resource "aws_security_group" "netmaker" {
  name        = "netmaker"
  description = "Allows traffic to Netmaker server"
  vpc_id      = module.netmaker_vpc.vpc_id
  tags = merge(local.tags, {
    Name = "netmaker"
  })
}

##
# Rules
##
resource "aws_security_group_rule" "ssh" {
  count = length(var.ssh_allowed_ipv4) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_allowed_ipv4
  ipv6_cidr_blocks  = var.ssh_allowed_ipv6
  security_group_id = aws_security_group.ssh.id
  description       = "SSH"
}

resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "ICMP"
}

resource "aws_security_group_rule" "stun" {
  type              = "ingress"
  from_port         = 3478
  to_port           = 3478
  protocol          = "udp"
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "STUN"
}

resource "aws_security_group_rule" "turn" {
  for_each = {
    for proto in ["tcp", "udp"] : proto => null
  }
  type              = "ingress"
  from_port         = 3479
  to_port           = 3479
  protocol          = each.key
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "TURN"
}

resource "aws_security_group_rule" "wireguard" {
  type              = "ingress"
  from_port         = split("-", var.netmaker_ports)[0]
  to_port           = split("-", var.netmaker_ports)[1]
  protocol          = "udp"
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "WireGuard"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "HTTP"
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.netmaker_allowed_ipv4
  ipv6_cidr_blocks  = var.netmaker_allowed_ipv6
  security_group_id = aws_security_group.netmaker.id
  description       = "HTTPS"
}

##
# EBS Volumes
##
resource "aws_ebs_volume" "netmaker_data" {
  availability_zone = module.netmaker_vpc.azs[1]
  size              = 2    # GB
  encrypted         = true # Using default key
  type              = "gp3"

  tags = merge(local.tags, {
    Name     = "netmaker-data"
    Snapshot = "${var.vpc_name}/true"
  })
}

resource "aws_volume_attachment" "netmaker" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.netmaker_data.id
  instance_id = aws_instance.netmaker.id
}

##
# EBS Snapshots
##
resource "aws_dlm_lifecycle_policy" "snapshots" {
  description        = "${var.vpc_name} - Weekly Snapshots"
  execution_role_arn = aws_iam_role.dlm_lifecycle.arn
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "1 week of daily snapshots"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["06:35"] # UTC
      }

      retain_rule {
        count = 7 # days
      }

      tags_to_add = merge(local.tags, {
        SnapshotCreator = "DLM"
      })

      copy_tags = true
    }

    target_tags = {
      Snapshot = "${var.vpc_name}/true"
    }
  }

  tags = merge(local.tags, {
    Name = "${var.vpc_name}-lifecycle-policy"
  })
}
