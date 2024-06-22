#Create a subnet group for Database 
resource "aws_db_subnet_group" "db-subnet" {
    name = var.db_subnet_name
    subnet_ids = [ var.subnet-2, var.subnet-3 ]
  
}
# Create a Database with created VPC 
resource "aws_db_instance" "rds" {
  allocated_storage = var.allocated_storage
  db_name = var.db_name
  engine = var.db_engine
  engine_version = var.db_engine
  username = var.db_username
  password = var.db_password
  instance_class = var.db_instance_class
  skip_final_snapshot = var.db_final_snapshot
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [ var.sg_id ]

  tags = {
    Name = var.db_tag_name
  }
}