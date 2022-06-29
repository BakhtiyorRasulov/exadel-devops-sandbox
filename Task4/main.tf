provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_instance" "ubuntu-server" {
    ami = var.ubuntu-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "Ubuntu"
    }
    user_data = "${file("ubuntu_tools.sh")}"
}