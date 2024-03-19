variable "profile" {
  type    = string
  default = "default"
}

variable "region-master" {
  type    = string
  default = "eu-north-1"
}

variable "region-worker" {
  type    = string
  default = "eu-west-2"
}

variable "your_external_ip" {
  type    = string
  default = "1.2.3.4/32"
}

variable "workers-count" {
  type    = number
  default = 1
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "remote_user" {
  type    = string
  default = "ec2-user"
}

variable "public_key_file" {
  type    = string
  default = "~/.ssh/id_rsa_ter.pub"
}

variable "private_key_file" {
  type    = string
  default = "~/.ssh/id_rsa_ter"
}

variable "webserver-port" {
  type    = number
  default = 8080
}
