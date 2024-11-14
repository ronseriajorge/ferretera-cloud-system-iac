resource "null_resource" "docker_commands" {
  provisioner "local-exec" {
    command = "docker tag api-gateway us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/api-gateway"
  }

  provisioner "local-exec" {
    command = "docker push us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/api-gateway"
  }

  provisioner "local-exec" {
    command = "docker tag inventario-ms us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/inventario-ms"
  }

  provisioner "local-exec" {
    command = "docker push us-east4-docker.pkg.dev/terraform-test-441302/microservices-repository/inventario-ms"
  }
}