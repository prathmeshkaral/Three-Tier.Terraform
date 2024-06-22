#VPC
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
#ec2

variable "private_ip" {
    type = list(string)
  
}
variable "ami_id" {
    type = string

  
}
variable "instance_type" {
    type = string
  
}
variable "key_name" {
    type = string
  
}
variable "instance_name" {
  type = list(string)
}
#Rds
variable "db_subnet_name" {
    type = string  
}
variable "allocated_storage" {
    type = number
  
}
variable "db_name" {
    type = string
  
}
variable "db_engine" {
    type = string
  
}
variable "db_version" {
    type = string
  
}
variable "db_username" {
    type = string
  
}
variable "db_password" {
    type = string
  
}
variable "db_instance_class" {
    type = string
  
}
variable "db_final_snapshot" {
    type = bool
  
}
variable "db_tag_name" {
    type = string
}