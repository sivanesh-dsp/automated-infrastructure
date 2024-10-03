provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "custom_ami_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.instance_key
  security_groups = [ "server-sg" ]

  root_block_device {
    volume_size = 15  # Size in GB
    volume_type = "gp2"  # General Purpose SSD (gp2) is the default type
  }

  tags = {
    Name = "Custom-AMI-Docker-Instance"
  }
}

resource "null_resource" "creating_user_in_jenkins" {
  depends_on = [aws_instance.custom_ami_instance]
  
  provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<EOT
      sleep 10;
      ansible-playbook -i ${aws_instance.custom_ami_instance.public_ip}, \
      --private-key ~/.ssh/${var.instance_key}.pem \
      ${path.module}/jenkins-user.yml
    EOT
  }
}