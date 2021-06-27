terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.13.0"
    }
  }
}

provider "docker" {host = "unix:///var/run/docker.sock"}

variable "ext_port" {
  type = number
  default = 8080
}

variable "container_count" {
  type = number
  default = 1
}

variable "int_port" {
  type = number
  default = 80 
}

# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:alpine"
}
#Create a random string for container names
resource "random_string" "random" {
  count   = var.container_count
  length  = 4
  special = false
  upper   = false

}

# Create a container
resource "docker_container" "nginx_container" {
  count = var.container_count
  image = docker_image.nginx.latest
  name  = join("-", ["nginx-container", random_string.random[count.index].result])
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

output "ip_address2" {
  value       = [for i in docker_container.nginx_container[*]: join(":", [i.ip_address], i.ports[*]["internal"])]
  description = "The name of nginx container1"
}
output "container_name" {
 value       = docker_container.nginx_container[*].name
 description = "The ip address of nginx container"
}