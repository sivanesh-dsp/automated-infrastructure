provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "custom_ami_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = var.instance_key
  security_groups = [ "server-sg" ]
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
      ~/poc4/modules/instance-module/jenkins-user.yml
    EOT
  }
}