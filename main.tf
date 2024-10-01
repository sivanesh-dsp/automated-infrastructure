module "packer" {
    source = "./modules/packer-module"
}

module "instance" {
  source = "./modules/instance-module"
  ami_id = trimspace(split(":", module.packer.image_name)[1]) 
}

module "docker" {
  source = "./modules/docker-module"
  instance_public_ip = module.instance.instance_public_ip
  instance_key = module.instance.security_key
}

module "ansible" {
  source = "./modules/ansible-module"
  instance_public_ip = module.instance.instance_public_ip
  instance_key = module.instance.security_key
}
