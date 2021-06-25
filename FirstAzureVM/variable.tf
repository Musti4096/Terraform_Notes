variable "prefix" {default = "tfvmex"}

variable "location" { default = "westeurope"}

variable "name_count" { default = ["server1", "server2", "server3"] }

variable "machine_size" {
    type = "map"
    default = {
        "dev" = "Standard_DS1_v2"
        "prod" = "Standard_DS2_v2"
    }
  
}