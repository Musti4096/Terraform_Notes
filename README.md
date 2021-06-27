# Terraform Notes

## join Function

    - we can join two values with this function

```bash
join("seperator", [value1, value2, "str"])

join(":", [docker_container.nginx_container.ip_address, docker_container.nginx_container.ports[0].external] )
```

## random function

```hcl
resource "random_string" "random" {
  length           = 8
  special          = true
  upper            = false
}
```

example

```hcl
resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nginx_container" {
  image = docker_image.nginx.latest
  name  = join("-", ["nginx-container", random_string.random.result])
  ports {
    internal = 80
    #external = 80
  }
}
```

## count.index

- We could create multiple resources using just one resource code
  and we can launch all values using count.index function

- Example

```hcl
resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false

}

# Create a container
resource "docker_container" "nginx_container" {
  count = 2
  image = docker_image.nginx.latest
  name  = join("-", ["nginx-container", random_string.random[count.index].result])
  ports {
    internal = 80
    #external = 80
  }
}
```

## Splat Expression

we could return all values from list ( multiple resource's attributes) using splat expression

```hcl
output "container_name" {
 value       = docker_container.nginx_container[*].name
 description = "The ip address of nginx container"
}
```

## for loops in terraform

- Getting values from list using for loops
- Example

```hcl
output "ip_address" {
  value       = [for i in docker_container.nginx_container[*]: join(":", [i.ip_address], i.ports[*]["internal"])]
  description = "The name of nginx container1"
}
output "container_name" {
 value       = docker_container.nginx_container[*].name
 description = "The ip address of nginx container"
}
```

## Taint in Terraform

- when we need force to replace any resource

```bash
terraform taint <resource name>

terraform taint resource.random_string[1].name
```

## State Locking , Break the state

```bash
terraform apply --auto-approve -lock=false # we unlock the state, and any one can change our state
# -lock=true is default value
```

- if the state and resource code conflicts, then we inspect state list and code.
  if we need we just add extra code, then use terraform import

## Terraform import

```bash
terraform import <resource id>
```

## Terraform Refresh and State rm

- We can update our state file with refresh command

```bash
terraform refresh #refresh all resources

terraform refresh -target docker_container.busyboy_container # refresh just mentioned resources
```

-delete one of resources from state file

```bash
terraform state rm random_string.random[1]
```

## Variables

```bash
TF_VAR_ext_port=8080 # we can export variable from cli

terraform apply --auto-approve -var ext_port=8080 # we could define variable with apply command
```

```hcl
variable "ext_port" {
  type = number
  default = 8080
}


resource "docker_container" "nginx_container" {
  count = 1
  image = docker_image.nginx.latest
  name  = join("-", ["nginx-container", random_string.random[count.index].result])
  ports {
    internal = 80
    external = var.ext_port
  }
}
```

## Variable Validation

- if we need validate our variables that we use with terraform

```hcl
variable "int_port" {
  type = number
  default = 8080

  validation {
    condition = var.int_port == 8080
    error_message = "The internal port must be 8080"
  }
}

variable "ext_port" {
  type = number
  default = 8080

  validation {
    condition = var.ext_port <= 65535 && var.ext_port > 0
    error_message = "The external port must be in the valid port range 0 - 65535"
  }
}

```

## Sensitive Variables

we create terrafor.tfvars file, and add sensetive variables into the this file.

## Variable Definition Precedence

- If we have two tfvars file, and consist of different values for same variable depends on department or region.
  Terraform uses terraform.tfvars as default, if we want to use another tfvars file then we should define it on cli as below

```bash
terraform apply --var-file dev_env.tfvars
terraform apply --var-file test_env.tfvars
terraform apply --var-file prod_env.tfvars
```

```bash

```

```bash

```

```bash

```

```bash

```
