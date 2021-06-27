output "ip_address2" {
  value       = [for i in docker_container.nginx_container[*]: join(":", [i.ip_address], i.ports[*]["internal"])]
  description = "The name of nginx container1"
}
output "container_name" {
 value       = docker_container.nginx_container[*].name
 description = "The ip address of nginx container"
}