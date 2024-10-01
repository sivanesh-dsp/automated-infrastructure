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


# Create Ansible inventory file for Jenkins and SonarQube
resource "local_file" "inventory_ini" {
  content = <<EOT
[Sonarqube]
sonarqube ansible_host=${var.instance_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${var.instance_key}.pem

EOT
  filename = "${path.module}/playbook/inventory.ini"
}

#Run docker without sudo
resource "null_resource" "docker-without-sudo" {
  depends_on = [ local_file.inventory_ini ]
    provisioner "local-exec" {
        environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    command = <<-EOT
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/playbook/docker.yml \
      -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    EOT
  }
}

# Define Docker volumes
# iterative
resource "docker_volume" "sonarqube_volumes" {
  depends_on = [ null_resource.docker-without-sudo ]
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
  
# Run Ansible Playbook after generating the inventory file
resource "null_resource" "sonarqube" {
  depends_on = [local_file.inventory_ini]
  
  provisioner "local-exec" {
        environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    command = <<-EOT
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/playbook/sonarqube-user.yml \
      -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    EOT
  }
}

resource "null_resource" "Jenkins" {
  depends_on = [null_resource.sonarqube]
  
  provisioner "local-exec" {
        environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    command = <<-EOT
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/playbook/jenkins.yml \
      -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    EOT
  }
}