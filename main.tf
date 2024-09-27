module "packer" {
    source = "./packer-module"
}

module "create-instance" {
  source = "./create-instance-module"
  ami_id = trimspace(split(":", module.packer.image_name)[1]) 
}

module "docker" {
  source = "./docker-module"
  instance_pulic_ip = module.create-instance.instance_public_ip
}
