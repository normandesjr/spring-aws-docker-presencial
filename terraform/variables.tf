variable "cidr_vpc" {
  default = "192.168.0.0/16"
}

variable "cidr_public" {
  default = "192.168.10.0/24"
}

variable "cidr_private" {
  default = "192.168.40.0/24"
}

variable "availability_zones" {
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1d",
    "us-east-1e",
    "us-east-1f",
  ]
}

variable "aws_linux_ami" {
  default = "ami-b70554c8" # Amazon Linux 2 AMI 2.0.20180622.1 x86_64 HVM 
}

variable "instance_type" {
  default = "t2.micro"
}

variable "my_public_cidr" {}

variable "db_password" {}
