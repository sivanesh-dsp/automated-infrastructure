terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"  # Ensure you set the required version
        }
    }
}

provider "docker" {
  host = "tcp://${ var.instance_pulic_ip }:2375"  
}

resource "docker_image" "jenkins" {
  name="sonarqube:alpine"
}
