ext_port = {
  nginx = {
    dev  = [80, 81]
    prod = [90, 91]
  }
  influxdb = {
    dev  = [8186, 8187]
    prod = [8086.8087]
  }
  grafana = {
    dev  = [3001, 3002]
    prod = [3000]
  }
}
