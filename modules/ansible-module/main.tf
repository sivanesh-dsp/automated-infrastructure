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

resource "null_resource" "sonarqube" {
  depends_on = [null_resource.docker-without-sudo]
  
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


resource "null_resource" "Jenkinsjob" {
  depends_on = [ null_resource.Jenkins ]  
  provisioner "local-exec" {
        environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    command = <<-EOT
      ansible-playbook -i ${path.module}/playbook/inventory.ini ${path.module}/playbook/job.yml \
      -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'"
    EOT
  }
}