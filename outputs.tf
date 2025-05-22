output "bastion_public_ip" {
  description = "Публичный IP Bastion хоста"
  value       = yandex_compute_instance.bastion.network_interface[0].nat_ip_address
}

output "web_a_private_ip" {
  description = "Приватный IP Web-a сервера"
  value       = yandex_compute_instance.web_a.network_interface[0].ip_address
}

output "web_b_private_ip" {
  description = "Приватный IP Web-b сервера"
  value       = yandex_compute_instance.web_b.network_interface[0].ip_address
}

output "alb_public_ip" {
  description = "Публичный IP Application Load Balancer"
  value       = yandex_alb_load_balancer.web_alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
}