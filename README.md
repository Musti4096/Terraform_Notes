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

```bash

```

```bash

```

```bash

```

```bash

```

```bash

```
