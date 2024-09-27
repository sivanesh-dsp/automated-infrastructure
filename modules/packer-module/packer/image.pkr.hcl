packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      version = "~> 1"
      source = "github.com/hashicorp/ansible"
    }
  }
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "custom-ami-docker"
  instance_type = "t2.micro"
  region        = "ap-south-1"
  source_ami = "ami-0522ab6e1ddcc7055"  # ubuntu 24.04
  ssh_username = "ubuntu"
    
  tags = {
    Name = "custom-ami-docker"
  }
}

build {
  name    = "docker-ami"
  sources = ["source.amazon-ebs.ubuntu"]

  provisioner "ansible" {
    playbook_file = "install_docker.yml"
  }

  post-processor "manifest" { 
    output = ".manifest.json"
    strip_path = true
  }
  post-processor "shell-local" { 
    inline = [
      "jq -r '.builds[-1].artifact_id' .manifest.json > .image_version"
    ]
  }
}
