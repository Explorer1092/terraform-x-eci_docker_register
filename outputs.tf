output "public_ip" {
  value = alicloud_eci_container_group.docker-register.internet_ip
}

output "private_ip" {
  value = alicloud_eci_container_group.docker-register.intranet_ip 
}

output "username" {
  value = "admin"
}

output "password" {
  value = random_password.default.result
}