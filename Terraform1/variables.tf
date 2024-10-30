variable "region"{
  default = "us-east-1"
  nullable = false
}

variable "node_nums" {
  default = 1
  nullable = false
}
variable "k8s_ami" {
  default = "ami-0866a3c8686eaeeba"
  nullable = false

}

variable "master_machine_type" {
  default = "t2.medium"
  nullable = false
}
variable "worker_machine_type" {
  default = "t2.medium"
  nullable = false
}

variable "key_name" {
  description = "name of the key pair to use for ssh access"
  type = string
}