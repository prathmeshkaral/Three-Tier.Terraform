#VPC
vpc_cidr_block           = "10.0.0.0/16"
vpc_name                 = "Three-tier-VPC"
subnet_cidr_block        = [ "10.0.1.0/24","10.0.2.0/24","10.0.3.0/24" ]
subnet_az                = [ "ap-northeast-1a","ap-northeast-1d","ap-northeast-1c" ]
public_ip                = [ "true","false" ]
subnet_name              = [ "Public-Nginx","Private-Tom","Private-DB" ]
igw_name                 = "Three-tier-igw"
sg_port                  = [ 0, 22, 80, 8080, 3306 ]
sg_name                  = "Three-Tier-sg"
private_ip               = [ "10.0.1.100/24","10.0.20.100/24","10.0.30.100/24" ]
#EC2
ami_id                   = "ami-0f9fe1d9214628296"
instance_type            = "t2.micro"
key_name                 = "Three-tier"
instance_name            = [ "Nginx","Tomcat","Database" ]
#RDS
db_subnet_name           = "rds_subnet_group"
allocated_storage        = 20
db_name                  = "student"
db_engine                = "mariadb"
db_version               = " 10.11.6"
db_username              = "admin"
db_password              = "12345678"
db_instance_class        = "db.t3.micro"
db_final_snapshot        = false
db_tag_name              = "mydatabase-1"