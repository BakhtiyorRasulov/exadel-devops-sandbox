provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_security_group" "centos-sg" {
  ingress {
    description = "ICMP"
    protocol = "icmp"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/32"]
  }

  ingress {
    description = "SSH"
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/32"]
  }

  ingress {
    description = "HTTP"
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/32"]
  }

  ingress {
    description = "HTTPS"
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


resource "aws_security_group" "ubuntu" {
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


resource "aws_instance" "centos-server" {
    ami = var.centos-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "CentOS"
    }
    vpc_security_group_ids = ["${aws_security_group.centos-sg.id}"]
    user_data = <<-EOF
                #!/bin/bash
                sudo yum -y update
                sudo yum -y install epel-relase
                sudo yum -y install nginx
                sudo systemctl enable nginx
                sudo systemctl start nginx
                cd /usr/share/nginx/html/
                sudo bash -c 'echo "Hello World from CentOS<br>" > index.html'
                sudo bash -c 'uname -sro >> index.html'
                EOF
}


resource "aws_instance" "ubuntu-server" {
    ami = var.ubuntu-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "Ubuntu"
    }
    vpc_security_group_ids = ["${aws_security_group.ubuntu.id}"]
    user_data = "${file("ubuntu_tools.sh")}"
}