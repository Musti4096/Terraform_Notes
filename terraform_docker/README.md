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

## Terraform Refresh and Terraform State rm

[Terraform Refresh](https://www.terraform.io/docs/cli/commands/refresh.html)

- The terraform refresh command reads the current settings from all managed remote objects and updates the Terraform state to match.

-This won't modify your real remote objects, but it will modify the the Terraform state.

```bash
terraform refresh

terraform refresh -target random_string.random #just targeted specific resources
```

[Terraform State rm](https://www.terraform.io/docs/cli/commands/state/rm.html)

- if someone delete our resources that we keep them state file,
  and we want to update our state file. In thias case we can use
  terraform state rm command. just remove deleted resources from state file.

```bash
terraform state rm random_string.random[1]
```

## Terraform Variables

[Variables ](https://www.terraform.io/docs/language/values/variables.html)

```hcl
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {}

variable "ext_port" {
  type    = number
  default = 80
}

variable "int_port" {
  type    = number
  default = 80
}

variable "container_count" {
  type    = number
  default = 1
}

resource "docker_image" "nginx_image" {
  name = "nginx:alpine"
}

resource "random_string" "random" {
  count   = 1
  length  = 4
  special = false
  upper   = false
}


resource "docker_container" "nginx_container" {
  count = var.container_count
  name  = join("-", ["nginx", random_string.random[count.index].result])
  image = docker_image.nginx_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port
  }
}

output "IP-Address" {
  value       = [for i in docker_container.nginx_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  description = "IP address of container"
}

output "container-name" {
  value = docker_container.nginx_container[*].name
}
```

## Variable Validation

[Custom Variable Rules](https://www.terraform.io/docs/language/values/variables.html#custom-validation-rules)

```hcl
variable "ext_port" {
  type    = number
  default = 80
  validation {
    condition     = var.ext_port == 80
    error_message = "The External port must be 80."
  }
}

variable "int_port" {
  type    = number
  default = 80
  validation {
    condition     = var.int_port <= 65535 && var.int_port > 0
    error_message = "The internal port must be in the valid port range 0 - 65535."
  }
}
```

```bash
Error: Invalid value for variable

  on main.tf line 11:
  11: variable "ext_port" {

The External port must be 80.

This was checked by the validation rule at main.tf:14,3-13.
```

## Sensitive Variables and .tfvars file

[Sensivite Variables](https://www.terraform.io/docs/language/values/variables.html#suppressing-values-in-cli-output)

- we just define variables in variables.tf file and put sensitive variables in to .tfvars file

```hcl
variable "ext_port" {
  type      = number
  sensitive = true
}
```

```bash

```

## Variable Definition Precedence

[link](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence)

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any _.auto.tfvars or _.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

```bash
terraform plan --var-file=centraf.tf #we just used anothter .tfvars file

terraform plan -var ext_port=1980 # we just mention our vars on cli
```

## Local Exec Provisioner

[Local-Exec Provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html)

```hcl
resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir nginxvol/ || true && sudo chown -R 1000:1000 nginxvol/"
  }
}
```

## Utilizing Local Values

[Local Values](https://www.terraform.io/docs/language/values/locals.html)

```hcl
locals {
  container_count = length(var.ext_port)
}

resource "docker_container" "nginx_container" {
  count = local.container_count
  name  = join("-", ["nginx", random_string.random[count.index].result])
  image = docker_image.nginx_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "/home/mustafa/Terraform/terraform-docker/nginxvol"
  }
}
```

## Min and Max Functions and Expand Expression

[Min and Max](https://www.terraform.io/docs/language/functions/min.html)

```hcl
max([10,20,30]...) > 30

variable "ext_port" {
  type = list(any)

  validation {
    condition     = max(var.ext_port...) <= 65535 && min(var.ext_port...) > 0
    error_message = "The internal port must be in the valid port range 0 - 65535."
  }
}
```

## Path References and String Interpolations

[Path references](https://www.terraform.io/docs/language/expressions/references.html#filesystem-and-workspace-info)

[Interpolation](https://www.terraform.io/docs/language/expressions/strings.html#interpolation)

```hcl
resource "docker_container" "nginx_container" {
  count = local.container_count
  name  = join("-", ["nginx", random_string.random[count.index].result])
  image = docker_image.nginx_image.latest
  ports {
    internal = var.int_port
    external = var.ext_port[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/nginxvol"
  }
}
```

## Maps and LookUps

[Map](https://www.terraform.io/docs/language/functions/map.html)
[Lookup](https://www.terraform.io/docs/language/functions/lookup.html)

```hcl
variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    dev  = "nginx:latest"
    prod = "nginx:alpine"
  }
}

resource "docker_image" "nginx_image" {
  name = lookup(var.image, var.env)
}
```

## Terraform Workspaces

[Workspace](https://www.terraform.io/docs/language/state/workspaces.html)

- we can also use workspace as a variable inside of resources and locals

```hcl
locals {
  container_count = length(lookup(var.ext_port, terraform.workspace))
}

resource "docker_container" "nginx_container" {
  count = local.container_count
  name  = join("-", ["nginx", terraform.workspace, random_string.random[count.index].result])
  image = docker_image.nginx_image.latest
  ports {
    internal = var.int_port
    external = lookup(var.ext_port, terraform.workspace)[count.index]
  }
  volumes {
    container_path = "/data"
    host_path      = "${path.cwd}/nginxvol"
  }
}

```

```bash
terraform workspace new dev # create a new called dev workspace and switch to it.

terraform workspace show #show the current working workspace

terraform workspace list # list all workspace

terraform select workspace dev # switch the dev ws.

```

## Terraform Modules

[]()

```hcl

```

```bash

```

## Terraform Graph

- shows our infra with graph
  []()

```hcl

```

```bash
sudo apt install graphviz # install graph program

terraform graph | dot -Tpdf > graph-plan.pdf # we can save our graph in a pdf file

terraform graph -type=plan=destroy | dot -Tpdf > graph-destroy.pdf # we just create a destroy graph
```

## Flatten Function

[Flatten](https://www.terraform.io/docs/language/functions/flatten.html)

- show seperated list values into a one list.

```hcl
output "IP-Address" {
  value       = flatten(module.container[*].ip-address)
  description = "IP address of container."
}

```

## Lifecycle on Terraform

[Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)

```hcl
resource "docker_volume" "container_volume" {
  name = "${var.name_in}-volume"
  lifecycle {
    prevent_destroy = true
  }
}

```

```bash
terraform destroy -target=module.container[0].docker_container.nginx_container #destroy just specific resource
```

## Terraform for_each parameter

[for each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)

```hcl
locals {
  deployment = {
    nginx = {
      image = var.image["nginx"][terraform.workspace]
    }
    influxdb = {
      image = var.image["influxdb"][terraform.workspace]
    }
  }
}

module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
}
```

```hcl
locals {
  deployment = {
    nginx = {
      image          = var.image["nginx"][terraform.workspace]
      int            = 80
      ext            = var.ext_port["nginx"][terraform.workspace]
      container_path = "/data"
    }
    influxdb = {
      image          = var.image["influxdb"][terraform.workspace]
      int            = 8086
      ext            = var.ext_port["influxdb"][terraform.workspace]
      container_path = "/var/lib/influxdb"
    }
  }
}

module "container" {
  source            = "./container"
  for_each          = local.deployment
  name_in           = join("-", [each.key, terraform.workspace, random_string.random[each.key].result])
  image_in          = module.image["nginx"].image_out
  int_port_in       = each.value.int
  ext_port_in       = each.value.ext
  container_path_in = each.value.container_path
}

```

## Dynamic Blocks

[Dynamic Blocks](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

[]()

```hcl

```

```bash

```

##

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
