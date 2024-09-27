terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"  # Ensure you set the required version
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.68.0"
    }
  }
}
