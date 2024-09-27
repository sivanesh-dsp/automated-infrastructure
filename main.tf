module "packer" {
    source = "./modules/packer-module"
}

module "create-instance" {
  source = "./modules/create-instance-module"
  ami_id = trimspace(split(":", module.packer.image_name)[1]) 
}

module "docker" {
  source = "./modules/docker-module"
  instance_pulic_ip = module.create-instance.instance_public_ip
}
