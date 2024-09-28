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