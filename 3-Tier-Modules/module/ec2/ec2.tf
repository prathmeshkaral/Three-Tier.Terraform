#Add network interface with public subnet to connet to public instance /nginx instance
resource "aws_network_interface" "Network" {
    subnet_id = var.subnet-1
    private_ip = var.private_ip[0]

}
#Create a instance for nginx and attach public-subnet
resource "aws_instance" "nginx" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    network_interface {
      network_interface_id = aws_network_interface.Network.id
      device_index = 0
    }
    tags = {
      Name = var.instance_name[0]

    }
  
}
#Attach the security group to instance
resource "aws_network_interface_sg_attachment" "sg-1" {
    security_group_id = var.sg_id
    network_interface_id = aws_instance.nginx.primary_network_interface_id
  
}
#Add network interface with private subnet 1 to connet to tomcat instance
resource "aws_network_interface" "tomcat" {
    subnet_id = var.subnet-2
    private_ip = var.private_ip[1]
  
}
#Create a instance for tomcat
resource "aws_instance" "Tomcat" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    network_interface {
      network_interface_id = aws_network_interface.tomcat.id
      device_index = 0
    }
    tags = {
      Name = var.instance_name[1]

    }
  
}
#Attach the security group to tomcat instance 
resource "aws_network_interface_sg_attachment" "tomcat-sg" {
    security_group_id = var.sg_id
    network_interface_id = aws_instance.Tomcat.primary_network_interface_id

}
#Add network interface with private subnet to connet to Database instance
resource "aws_network_interface" "Database" {
    subnet_id = var.subnet-3
    private_ip = var.private_ip[2]
  
}
#Create a instance for Database 
resource "aws_instance" "Database" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    network_interface {
      network_interface_id = aws_network_interface.Database.id
      device_index = 0
    }
    tags = {
      Name = var.instance_name[2]

    }
  
}
#Attach the security group to database instance
resource "aws_network_interface_sg_attachment" "database-sg" {
    security_group_id = var.sg_id
    network_interface_id = aws_instance.Database.primary_network_interface_id
  
}