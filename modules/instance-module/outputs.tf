output "instance_public_ip" {
  value = aws_instance.custom_ami_instance.public_ip
}

output "instance_id" {
  value = aws_instance.custom_ami_instance.id
}

output "security_key" {
  value = aws_instance.custom_ami_instance.key_name
}