# Terraform Notes

## Terraform Lock Hcl file

it locks all versions for us.

## Terraform plan and apply

```bash
terraform plan -out=plan1 # we define our plan as plan1

terraform apply plan1 # execute our plan wihtout confirmation
```

## Terraform State

- we cna store our state file in our local machine, remote state ( blob or terraform cloud)

```bash
terraform show -json #it shows our state file with json format

terraform state list #list the resources that we created
```

## Terraform Console

- we use console for some testing issues

```bash
terraform console # we can enter console

docker_container.nginx_container.ip_address #we can reach container ip address.
```

## Terraform Output

[Terraform Outputs](https://www.terraform.io/docs/language/values/outputs.html)

- it gives us some information about our resources
  and we can consume them in another resource

```hcl
output "IP-Address" {
  value       = docker_container.nginx_container.ip_address
  description = "IP address of container"
}

output "container-name" {
  value = docker_container.nginx_container.name
}
```

```bash
terraform output #with that command we can see all outputs
```

## Terraform Functions

[Terraform Functions](https://www.terraform.io/docs/language/functions/index.html)

### Join Function

[Join Function](https://www.terraform.io/docs/language/functions/join.html)

```hcl
join (seperator, list)

join ", ", ["foo", "bar", "baz"]

```

```bash
join(":", [docker_container.nginx_container.ip_address, docker_container.nginx_container.ports[0].external]) #we can join ip address and ports then use it in output
```

## Terraform Random Resources

[Random Resource](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

```hcl
resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}
```

```hcl
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}
provider "docker" {}

resource "docker_image" "nginx_image" {
  name = "nginx:alpine"
}

resource "random_string" "random" {
  length  = 4
  special = false
  upper   = false
}

resource "random_string" "random2" {
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "nginx_container" {
  name  = join("-", ["nginx", random_string.random.result])
  image = docker_image.nginx_image.latest
  ports {
    internal = "80"
    # external = "80"
  }
}

resource "docker_container" "nginx_container2" {
  name  = join("-", ["nginx", random_string.random2.result])
  image = docker_image.nginx_image.latest
  ports {
    internal = "80"
    # external = "80"
  }
}

output "IP-Address" {
  value       = join(":", [docker_container.nginx_container.ip_address, docker_container.nginx_container.ports[0].external])
  description = "IP address of container"
}

output "container-name" {
  value = docker_container.nginx_container.name
}

output "container-name-2" {
  value = docker_container.nginx_container2.name
}

```

## Multiple Resources and Count

[Terraform Count](https://www.terraform.io/docs/language/meta-arguments/count.html)

```hcl
resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}

```

```hcl
resource "docker_image" "nginx_image" {
  name = "nginx:alpine"
}

resource "random_string" "random" {
  count   = 2
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nginx_container" {
  count = 2
  name  = join("-", ["nginx", random_string.random[count.index].result])
  image = docker_image.nginx_image.latest
  ports {
    internal = "80"
    # external = "80"
  }
}


output "IP-Address" {
  value       = join(":", [docker_container.nginx_container[0].ip_address, docker_container.nginx_container[0].ports[0].external])
  description = "IP address of container"
}

output "container-name" {
  value = docker_container.nginx_container[0].name
}

output "container2-name" {
  value = docker_container.nginx_container[1].name
}
```

## The Splat Expression

[The Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)

```hcl

output "container-name" {
  value = docker_container.nginx_container[*].name
}

```

## For Loops

[For Expression](https://www.terraform.io/docs/language/expressions/for.html)

```hcl

output "IP-Address" {
  value       = [for i in docker_container.nginx_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "IP address of container"
}

output "container-name" {
  value = docker_container.nginx_container[*].name
}

```

```bash
[for i in docker_container.nginx_container[*] : join(":", [i.ip_address], [i.ports[0]["external"]])]

[for i in docker_container.nginx_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
```

## Tainting a Source

- If we want to force some resource to reload and reinstall,
  then we just use tainting

[Tainting](https://www.terraform.io/docs/cli/commands/taint.html)

```bash
terraform taint random_string.random[0] #just tainted a resource

terraform untaint random_string.random[0] #just untainted a resource
```

## State Locking and Breaking State

```bash
terraform apply -lock=false #we just unlock the state
                            # default is lock=true
```

## Terraform Import

[Terraform Import](https://www.terraform.io/docs/cli/import/index.html)

- if we have more resources out of state, we can include them
  to our state file with import command

- first we add resources to our .tf file, then use terraform import <resource_id> command

```bash
terraform import docker_container.nginx_container-2 $(docker inspect -f {{.ID}} nginx-yrwl)
```

[]()

```hcl

```

```bash

```

[]()

```hcl

```

```bash

```

[]()

```hcl

```

```bash

```
