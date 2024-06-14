provider "aws" {
    region = "us-east-1"
    profile = "tf-user"
  
}
#Create A VPC 
resource "aws_vpc" "Demo" {
    cidr_block = "192.168.0.0/16"
    tags = {
      Name = "vpc-tf"
    }
  
}
#Create a Public subnet for nginx
resource "aws_subnet" "public-nginx" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = "192.168.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = {
      Name = "public-nginx"
    }
  
}
#Create a private subnet for tomcat
resource "aws_subnet" "private-tom" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = "192.168.1.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    
    tags = {
      Name = "private-Tomcat"
    }
  
}
#Create a private subnet for database
resource "aws_subnet" "private-db" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = "192.168.2.0/24"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = false

    tags = {
      Name = "private-Database"
    }
  
}
#Create a internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.Demo.id

    tags = {
      Name = "igw-tf"
    }
  
}
#Create a elastic ip
resource "aws_eip" "elasticip" {
    domain = "vpc"
  
}
#Create a NAT gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.elasticip.id
    subnet_id = aws_subnet.public-nginx.id
  
}
#Create a public route table
resource "aws_route_table" "pub-RT" {
    vpc_id = aws_vpc.Demo.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}
#Create a public route table and public subnet association
resource "aws_route_table_association" "pub-assosiation" {
    subnet_id = aws_subnet.public-nginx.id
    route_table_id = aws_route_table.pub-RT.id
  
}
#Create a private route table
resource "aws_route_table" "priv-RT" {
    vpc_id = aws_vpc.Demo.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
  
}
#Create a private route table and private subnet association for tomcat
resource "aws_route_table_association" "private-assosiation-tom" {
    subnet_id = aws_subnet.private-tom.id
    route_table_id = aws_route_table.priv-RT.id
  
}
#Create a private route table and private subnet association for database
resource "aws_route_table_association" "private-association-db" {
    subnet_id = aws_subnet.private-db.id
    route_table_id = aws_route_table.priv-RT.id
  
}
# Create a Security group
resource "aws_security_group" "ssh" {
    name = "Three-tier"
    vpc_id = aws_vpc.Demo.id
  
}

#Add port 22,80,8080,3306 in inbound rule
resource "aws_vpc_security_group_ingress_rule" "inbound" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22

}
resource "aws_vpc_security_group_ingress_rule" "nginx" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80

}
resource "aws_vpc_security_group_ingress_rule" "Tomcat" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 8080
    ip_protocol = "tcp"
    to_port = 8080

}
resource "aws_vpc_security_group_ingress_rule" "db" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 3306
    ip_protocol = "tcp"
    to_port = 3306

}
#Add outbound rule
resource "aws_vpc_security_group_egress_rule" "outbound" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 0
    ip_protocol = "-1"
    to_port = 0
  
}
#Add network interface with public subnet to connet to public instance /nginx instance
resource "aws_network_interface" "Network" {
    subnet_id = aws_subnet.public-nginx.id
    private_ip = "192.168.1.100"

}

#Create a instance for nginx and attach public-subnet
resource "aws_instance" "nginx" {
    ami = "ami-08a0d1e16fc3f61ea"
    instance_type = "t2.micro"
    key_name = "nat.key"
    network_interface {
      network_interface_id = aws_network_interface.Network.id
      device_index = 0
    }
    tags = {
      Name = "Public-nginx"

    }
  
}

#Attach the security group to instance
resource "aws_network_interface_sg_attachment" "sg-1" {
    security_group_id = aws_security_group.ssh.id
    network_interface_id = aws_instance.nginx.primary_network_interface_id
  
}

#Add network interface with private subnet 1 to connet to tomcat instance
resource "aws_network_interface" "tomcat" {
    subnet_id = aws_subnet.private-tom.id
    private_ip = "192.168.20.100"
  
}
#Create a instance for tomcat
resource "aws_instance" "Tomcat" {
    ami = "ami-08a0d1e16fc3f61ea"
    instance_type = "t2.micro"
    key_name = "nat.key"
    network_interface {
      network_interface_id = aws_network_interface.tomcat.id
      device_index = 0
    }
    tags = {
      Name = "Private-Tomcat"

    }
  
}
#Attach the security group to tomcat instance 
resource "aws_network_interface_sg_attachment" "tomcat-sg" {
    security_group_id = aws_security_group.ssh.id
    network_interface_id = aws_instance.Tomcat.primary_network_interface_id

}
#Add network interface with private subnet to connet to Database instance
resource "aws_network_interface" "Database" {
    subnet_id = aws_subnet.private-db.id
    private_ip = "192.168.30.100"
  
}
#Create a instance for Database 
resource "aws_instance" "Database" {
    ami = "ami-08a0d1e16fc3f61ea"
    instance_type = "t2.micro"
    key_name = "nat.key"
    network_interface {
      network_interface_id = aws_network_interface.Database.id
      device_index = 0
    }
    tags = {
      Name = "Private-Database"

    }
  
}
#Attach the security group to tomcat instance
resource "aws_network_interface_sg_attachment" "database-sg" {
    security_group_id = aws_security_group.ssh.id
    network_interface_id = aws_instance.Database.primary_network_interface_id
  
}
#Create a subnet group for Database 
resource "aws_db_subnet_group" "db-subnet" {
    name = "db-subnet"
    subnet_ids = [aws_subnet.private-tom.id,aws_subnet.private-db.id]
  
}
# Create a Database with created VPC 
resource "aws_db_instance" "rds" {
  allocated_storage = 20
  db_name = "Student"
  engine = "mariadb"
  engine_version = "10.11.6"
  username = "admin"
  password = "12345678"
  instance_class = "db.t3.micro"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "Student2"
  }
}
