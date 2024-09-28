module "packer" {
    source = "./modules/packer-module"
}

module "instance" {
  source = "./modules/instance-module"
  ami_id = trimspace(split(":", module.packer.image_name)[1]) 
}

module "docker" {
  source = "./modules/docker-module"
  instance_pulic_ip = module.instance.instance_public_ip
}
