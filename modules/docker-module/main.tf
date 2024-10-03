terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"  # Ensure you set the required version
        }
    }
}

  provider "docker" {
    host = "tcp://${ var.instance_public_ip }:2375"  
  }

resource "null_resource" "docker-without-sudo" {
    provisioner "local-exec" {
        environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    command = <<-EOT
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/docker.yml \
      -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    EOT
  }
}
# Define Docker volumes
# iterative
resource "docker_volume" "sonarqube_volumes" {
  for_each = var.sonarqube_volumes
    name = each.key
}

# Define Docker container
resource "docker_container" "sonarqube" {
  depends_on = [ docker_volume.sonarqube_volumes ]
  image = var.sonarqube_image
  name  = var.sonarqube_container_name
  ports {
    internal = 9000
    external = var.sonarqube_ports["9000"]
  }
  dynamic "volumes" {
    for_each = var.sonarqube_volumes
    content {
      volume_name    = volumes.key
      container_path = volumes.value
    }
  }
}
