variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    nginx = {
      dev  = "nginx:alpine"
      prod = "nginx:latest"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }
    grafana = {
      dev  = "grafana/grafana"
      prod = "grafana/grafana"
    }
  }
}
variable "ext_port" {
  type = map(any)

  # validation {
  #   condition     = max(var.ext_port["dev"]...) <= 65535 && min(var.ext_port["dev"]...) > 0
  #   error_message = "The internal port must be in the valid port range 0 - 65535."
  # }

  # validation {
  #   condition     = max(var.ext_port["prod"]...) <= 65535 && min(var.ext_port["prod"]...) > 0
  #   error_message = "The internal port must be in the valid port range 0 - 65535."
  # }
}

variable "int_port" {
  type    = number
  default = 80
}

# locals {
#   container_count = length(var.ext_port[terraform.workspace])
# }

# variable "container_count" {
#   type = number

# }

