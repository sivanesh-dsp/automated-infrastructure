resource "terraform_data" "packer_image" {  
  provisioner "local-exec" {
    when = create
    working_dir = "${path.module}/packer/"
    command     = "packer build image.pkr.hcl"
  }
}
data "local_file" "image_version" {
  filename = "${path.module}/packer/.image_version"
  depends_on = [ terraform_data.packer_image ]
}