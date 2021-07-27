locals {
  deployment = {
    nginx = {
      container_count = length(var.ext_port["nginx"][terraform.workspace])
      image           = var.image["nginx"][terraform.workspace]
      int             = 80
      ext             = var.ext_port["nginx"][terraform.workspace]
      volumes = [
        { container_path_each = "/data" }
      ]
    }
    influxdb = {
      container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image           = var.image["influxdb"][terraform.workspace]
      int             = 8086
      ext             = var.ext_port["influxdb"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/influxdb" }
      ]
    }
    grafana = {
      container_count = length(var.ext_port["grafana"][terraform.workspace])
      image           = var.image["grafana"][terraform.workspace]
      int             = 3000
      ext             = var.ext_port["grafana"][terraform.workspace]
      volumes = [
        { container_path_each = "/var/lib/" },
        { container_path_each = "/etc/grafana" }
      ]
    }
  }
}
