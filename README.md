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

```bash

```

```bash

```

```bash

```
