module "vpc" {
    source                = "./module/vpc"
    vpc_cidr_block        = var.vpc_cidr_block
    vpc_name              = var.vpc_name
    subnet_cidr_block     = var.subnet_cidr_block
    subnet_az             = var.subnet_az
    public_ip             = var.public_ip
    subnet_name           = var.subnet_name
    igw_name              = var.igw_name
    sg_port               = var.sg_port
    sg_name               = var.sg_name
    
  
}
module "ec2" {
    source                = "./module/ec2"
    ami_id                = var.ami_id
    instance_type         = var.instance_type
    key_name              = var.key_name
    instance_name         = var.instance_name
    subnet-1              = module.vpc.pub_subnet_id
    subnet-2              = module.vpc.priv1_subnet_id
    subnet-3              = module.vpc.priv_subnet_id
    sg_id                 = module.vpc.sg_id
   private_ip             = var.private_ip
  
}

module "rds" {
    source                = "./module/rds"
    db_subnet_name        = var.db_subnet_name
    allocated_storage     = var.allocated_storage
    db_name               = var.db_name
    db_engine             = var.db_engine
    db_version            = var.db_version
    db_username           = var.db_username
    db_password           = var.db_password
    db_instance_class     = var.db_instance_class
    db_final_snapshot     = var.db_final_snapshot
    db_tag_name           = var.db_tag_name
    subnet-2              = module.vpc.priv1_subnet_id
    subnet-3              = module.vpc.priv_subnet_id
    sg_id                 = module.vpc.sg_id
  
}