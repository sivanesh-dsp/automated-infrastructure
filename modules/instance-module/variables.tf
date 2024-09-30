variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Type of instance"
  type = string
  default = "t2.medium"
}

variable "instance_key" {
  description = "The key (.pem) to acces the instance"
  type = string
  default = "guvi-cprime"
}