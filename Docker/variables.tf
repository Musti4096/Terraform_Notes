variable "ext_port" {
  type = number

  validation {
    condition = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be in the valid port range 0 - 65535."
  }
}

variable "container_count" {
  type = number
  default = 1
}

variable "int_port" {
  type = number

  validation {
    condition = var.int_port == 8080
    error_message = "The internal port must be 8080."
  }
}
