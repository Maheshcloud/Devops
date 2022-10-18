
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ssh_key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}
