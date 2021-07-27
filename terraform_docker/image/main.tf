# ------Image Module main.tf -------

resource "docker_image" "container_image" {
  name = var.image_in
}
