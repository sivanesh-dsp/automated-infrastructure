resource "local_file" "inventory_ini" {
  content = <<EOT
  [Sonarqube]
  sonarqube ansible_host=${var.instance_public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/${var.instance_key}.pem
    EOT
  filename = "${path.module}/playbook/inventory.ini"
}


resource "null_resource" "sonarqube" {
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