##
# Netmaker
##
output "netmaker_server_url" {
  value       = "https://dashboard.${var.netmaker_domain}"
  description = "Dashboard URL for the Netmaker server"
}

output "netmaker_server_ip" {
  value       = aws_eip.netmaker.public_ip
  description = "Public IP for the Netmaker server"
}

##
# Volumes
##
output "netmaker_volume_device" {
  value       = "/dev/disk/by-id/nvme-Amazon_Elastic_Block_Store_${replace(aws_volume_attachment.netmaker.volume_id, "-", "")}"
  description = "EBS device name exposed to the instance for Netmaker"
}
