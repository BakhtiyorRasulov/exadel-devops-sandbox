# Task4 of devops sandbox #

- [x] 1. Install docker
- [x] 2. Run any docker Hello World container
- [x] 3. Create dockerfile with any web service
- [x] 4. Push docker image
- [x] 5. Create docker compose file


### Step 1 ###

First we download and unzip terraform.exe from official website.
Once we unzip and moved it to preferable directory, we will add terraform to path, to access terraform.exe from whichever directory we are.

Then inside our Task3 directory we create terraform file, main.tf.
In this we specify that we use AWS as our provider since we are using aws.

```terraform
provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}
```

access_key and secret_key are our keys to use our account aws resources. We can take those from:
	Security Credentials > Access keys
Who ever can see our access and secret keys are able to launch instance from our account.
So we need to hide it.

I created variables.tf file and defined variables:

```terraform
variable "access_key" {
  description = "AWS access key"
  type = string
  sensitive = true
}

variable "secret_key" {
  description = "AWS secret key"
  type = string
  sensitive = true
}
```

`sensitive = true` makes it hidden inside program and logs, 
but our keys will be visible if we wrote them here with like:

```terraform
variable "secret_key" {
  description = "AWS secret key"
  type = string
  sensitive = true
  default = mysecretkey
}
```

so we create another secret.tfvars file to declare there:
```
secret_key = "mysecretkey"
access_key = "myaccesskey"
```
variable name in secret.tfvars should be same as variables.tf.


Back to main.tf, we create resources of aws.
```
resource "aws_instance" "ubuntu-server" {
    ami = var.ubuntu-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "Ubuntu"
    }

resource "aws_instance" "centos-server" {
    ami = var.centos-ami
    instance_type = "t2.micro"
    key_name = "keypair1devops2"
    tags = {
      Name = "CentOS"
    }
```

### Step 2 ###

To create custom port access we should create security group:
```
resource "aws_security_group" "ubuntu" {
  ingress {
    description = "ICMP"
    protocol = "icmp"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
...
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
```

After that we should declare that our Ubuntu instance created in previous step should use this security group.
We simply add this line inside ubuntu instance:
`vpc_security_group_ids = ["${aws_security_group.ubuntu.id}"]`

### Step 3. ###

We create security group again, but this time we should allow connection only from local network

```
resource "aws_security_group" "centos-sg" {
  ingress {
    description = "ICMP"
    protocol = "icmp"
    from_port = 0
    to_port = 0
    cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/24"]
  }
...
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
```

If we specify cidr as 24 it will be 256 ip addresses and actual 254 usable ip address


### Step 4 ###

We specify what commands to run when machine is run inside our instance with:
```
user_data = user_data = "${file("ubuntu_tools.sh")}"
```
we can git clone our script from github and write execution command inside `user_data`

### Step 5 ###
We do what is said in https://docs.docker.com/engine/install/ubuntu/
Also we could add commands into our script so when web servers are created we can create docker as well

### Step 6 ###

What we do here is we create another variable for each instance inside variables.tf:

```
variable "ubuntu-ami" {
  description = "Image id of Ubuntu"
  type = string
  sensitive = false
  default = "ami-052efd3df9dad4825"
}

variable "centos-ami" {
  description = "Image id of centos"
  type = string
  sensitive = false
  default = "ami-02358d9f5245918a3"
}
```

### Step 7 ###

Only thing to do is change cidr block inside security group.
So it will be from:
`cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/24"]`
to
`cidr_blocks = ["${aws_instance.ubuntu-server.private_ip}/32"]`

Cidr 32 means one ip address. If 174.18.2.12/32 it means same ip, but if it is /24 then from 0 to 255