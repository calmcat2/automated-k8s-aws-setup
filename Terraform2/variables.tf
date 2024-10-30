variable "node_names" {
  default = ["worker01", "worker02"]

}
variable "k8s_ami" {
  default = "ami-0866a3c8686eaeeba"

}
variable "ansible_machine_type" {
  default = "t2.medium"
}

variable "ansible_ami" {
  default = "ami-0866a3c8686eaeeba"
}

variable "master_machine_type" {
  default = "t2.medium"
}
variable "worker_machine_type" {
  default = "t2.medium"
}
variable "key_name" {
  description = "name of the key pair to use for ssh access"
  type = string
}