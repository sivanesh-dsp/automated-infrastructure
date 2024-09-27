provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "custom_ami_instance" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name = "guvi-cprime"
  # vpc_security_group_ids = ["sg-0ae16c146447cb0de"]  
  security_groups = [ "server-sg" ]
  tags = {
    Name = "Custom-AMI-Docker-Instance"
  }
}