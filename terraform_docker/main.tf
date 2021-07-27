
module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
}

module "container" {
  source      = "./container"
  count_in    = each.value.container_count
  for_each    = local.deployment
  name_in     = each.key
  image_in    = each.value.image
  int_port_in = each.value.int
  ext_port_in = each.value.ext
  volumes_in  = each.value.volumes
  # name_in           = join("-", [each.key, terraform.workspace, random_string.random[each.key].result])
}
