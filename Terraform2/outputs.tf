
output "k8s_master_public_IP" {
  description = "k8s master node Public IP"
  value       = aws_instance.k8s_master.public_ip
}
output "k8s_master_private_IP" {
  description = "k8s master node Private IP"
  value       = aws_instance.k8s_master.private_ip
}

output "k8s_worker_public_IPs" {
  description = "k8s worker nodes' Public IP"
  value       = aws_instance.k8s_workers[*].public_ip
}
output "k8s_worker_private_IPs" {
  description = "k8s worker nodes' Private IP"
  value       = aws_instance.k8s_workers[*].private_ip
}