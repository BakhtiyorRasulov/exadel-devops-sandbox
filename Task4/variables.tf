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
