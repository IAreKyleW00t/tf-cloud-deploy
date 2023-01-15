##
# Security Groups
##
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allows SSH traffic from specific IPs"
  vpc_id      = module.vpc.vpc_id
  tags = merge(local.tags, {
    Name = "ssh"
  })
}

resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow public HTTP/HTTPS traffic"
  vpc_id      = module.vpc.vpc_id
  tags = merge(local.tags, {
    Name = "web"
  })
}

resource "aws_security_group" "netclient" {
  name        = "netclient"
  description = "Allow traffic between clients on NetMaker network"
  vpc_id      = module.vpc.vpc_id
  tags = merge(local.tags, {
    Name = "netclient"
  })
}

resource "aws_security_group" "netclient_public" {
  name        = "netclient-public"
  description = "Allow public traffic to Netmaker client"
  vpc_id      = module.vpc.vpc_id
  tags = merge(local.tags, {
    Name = "netclient-public"
  })
}

resource "aws_security_group" "unifi" {
  name        = "unifi"
  description = "Allow traffic to UniFi application"
  vpc_id      = module.vpc.vpc_id
  tags = merge(local.tags, {
    Name = "unifi"
  })
}

##
# Rules
##
resource "aws_security_group_rule" "ssh" {
  count = length(var.ssh_allowed_ips) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.ssh_allowed_ips
  security_group_id = aws_security_group.ssh.id
  description       = "SSH"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
  description       = "HTTP"
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
  description       = "HTTPS"
}

resource "aws_security_group_rule" "netmaker" {
  type              = "ingress"
  from_port         = 51821
  to_port           = 51821
  protocol          = "udp"
  cidr_blocks       = ["${data.aws_eip.netmaker.public_ip}/32"]
  security_group_id = aws_security_group.netclient.id
  description       = "Netmaker"
}

resource "aws_security_group_rule" "wireguard" {
  type              = "ingress"
  from_port         = 51821
  to_port           = 51821
  protocol          = "udp"
  self              = true # Allow traffic from other netclients
  security_group_id = aws_security_group.netclient.id
  description       = "WireGuard"
}

resource "aws_security_group_rule" "wireguard_extras" {
  count = length(var.additional_netclient_ips) > 0 ? 1 : 0

  type              = "ingress"
  from_port         = 51821
  to_port           = 51821
  protocol          = "udp"
  cidr_blocks       = var.additional_netclient_ips
  security_group_id = aws_security_group.netclient.id
  description       = "WireGuard"
}

resource "aws_security_group_rule" "wireguard_public" {
  type              = "ingress"
  from_port         = 51821
  to_port           = 51821
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.netclient_public.id
  description       = "WireGuard"
}

resource "aws_security_group_rule" "unifi_stun" {
  type              = "ingress"
  from_port         = 3478
  to_port           = 3478
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi STUN"
}

resource "aws_security_group_rule" "unifi_control" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi Control"
}

resource "aws_security_group_rule" "unifi_api" {
  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi API"
}

resource "aws_security_group_rule" "unifi_http" {
  type              = "ingress"
  from_port         = 8880
  to_port           = 8880
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi HTTP"
}

resource "aws_security_group_rule" "unifi_https" {
  type              = "ingress"
  from_port         = 8843
  to_port           = 8843
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi HTTPS"
}

resource "aws_security_group_rule" "unifi_speedtest" {
  type              = "ingress"
  from_port         = 6789
  to_port           = 6789
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi SpeedTest"
}

resource "aws_security_group_rule" "unifi_discovery" {
  type              = "ingress"
  from_port         = 10001
  to_port           = 10001
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi Discovery"
}

resource "aws_security_group_rule" "unifi_l2_discovery" {
  type              = "ingress"
  from_port         = 1900
  to_port           = 1900
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.unifi.id
  description       = "UniFi L2 Discovery"
}
