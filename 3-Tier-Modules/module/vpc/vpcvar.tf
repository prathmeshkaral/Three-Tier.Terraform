variable "vpc_cidr_block" {
    type = string
  
}
variable "vpc_name" {
    type = string
  
}
variable "subnet_cidr_block" {
    type = list(string)
  
}
variable "subnet_az" {
    type = list(string)
  
}
variable "public_ip" {
    type = list(bool)
  
}
variable "subnet_name" {
    type = list(string)
  
}
variable "igw_name" {
    type = string
  
}
variable "sg_port" {
    type = list(number)
  
}
variable "sg_name" {
    type = string
  
}