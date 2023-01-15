##
# Domains
##
output "public_cdn_domain" {
  value       = var.cdn_domain
  description = "Public domain for CDN"
}

output "ingress_domain" {
  value       = var.ingress_domain
  description = "Public ingress domain"
}

output "additional_domains" {
  value       = keys(var.additional_domains)
  description = "Additional domains created (CNAMEd to ingress_domain)"
}

##
# Netmaker
##
output "additional_netclient_ips" {
  value       = var.additional_netclient_ips
  description = "List of additional Netclient IPs (in CIDR notation) to allow direct WireGuard traffic from"
}

##
# Instances
##
output "topaz" {
  description = "Public IP and EBS volumes for the topaz instance"
  value = {
    "public_ip" = aws_eip.topaz.public_ip,
    "volumes" = {
      "unifi" = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.unifi.volume_id, "-", "")}"
    }
  }
}

output "padparadscha" {
  description = "Public IP and EBS volumes for the padparadscha instance"
  value = {
    "public_ip" = aws_instance.padparadscha.public_ip,
    "volumes" = {
      "bitwarden" = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.bitwarden.volume_id, "-", "")}",
      "heimdall"  = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.heimdall.volume_id, "-", "")}",
      "kuma"      = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.kuma.volume_id, "-", "")}",
      "znc"       = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.znc.volume_id, "-", "")}",
    }
  }
}

output "fluorite" {
  description = "Public IP and EBS volumes for the fluorite instance"
  value = {
    "public_ip" = aws_instance.fluorite.public_ip,
    "volumes"   = {}
  }
}
