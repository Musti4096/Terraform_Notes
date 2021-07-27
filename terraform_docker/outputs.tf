# output "IP-Address" {
#   value       = flatten(module.container[*].ip-address)
#   description = "IP address of container."
# }

# output "container-name" {
#   value = module.container[*].container-name
# }

output "application_access" {
  value       = [for x in module.container[*] : x]
  description = "The name and socket for each application."

}
