provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_security_group" "standard_in_out" {
  ingress {
    description = "ICMP"
    protocol = "icmp"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https"
    protocol = "tcp"
    from_port = 443
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "centos-ansible" {
    ami = var.centos-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "CentosAnsibleControlCentre"
    }
    vpc_security_group_ids = ["${aws_security_group.standard_in_out.id}"]
    user_data = "${file("ubuntu_tools.sh")}"
}


resource "aws_instance" "centos2" {
    ami = var.centos-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "CentosMachine1"
    }
    vpc_security_group_ids = ["${aws_security_group.standard_in_out.id}"]
}


resource "aws_instance" "centos1" {
    ami = var.centos-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "CentosMachine2"
    }
    vpc_security_group_ids = ["${aws_security_group.standard_in_out.id}"]

}