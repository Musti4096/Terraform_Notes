# #----- container module
# output "ip-address" {
#   value       = [for i in docker_container.nginx_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
#   description = "IP address of container."
# }

# output "container-name" {
#   value = docker_container.nginx_container.name
# }

output "application_access" {
  value = { for x in docker_container.app_container[*] : x.name => join(":", [x.ip_address], x.ports[*]["external"]) }
}
