#Create A VPC 
resource "aws_vpc" "Demo" {
    cidr_block = var.vpc_cidr_block
    tags = {
      Name = var.vpc_name
    }
  
}
#Create a Public subnet for nginx
resource "aws_subnet" "pub-nginx" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = var.subnet_cidr_block[0]
    availability_zone = var.subnet_az[0]
    map_public_ip_on_launch = var.public_ip[0]
    
    tags = {
      Name = var.subnet_name[0]
    }
  
}
#Create a private subnet for tomcat
resource "aws_subnet" "priv-tom" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = var.subnet_cidr_block[1]
    availability_zone = var.subnet_az[1]
    map_public_ip_on_launch = var.public_ip[1]
    
    tags = {
      Name = var.subnet_name[1]
    }
  
}
#Create a private subnet for database
resource "aws_subnet" "priv-db" {
    vpc_id = aws_vpc.Demo.id
    cidr_block = var.subnet_cidr_block[2]
    availability_zone = var.subnet_az[2]
    map_public_ip_on_launch = var.public_ip[1]

    tags = {
      Name = var.subnet_name[2]
    }
  
}
#Create a internet gateway 
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.Demo.id

    tags = {
      Name = var.igw_name
    }
  
}
#Create a elastic ip
resource "aws_eip" "elasticip" {
    domain = "vpc"
  
}
#Create a NAT gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.elasticip.id
    subnet_id = aws_subnet.pub-nginx.id
  
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
    subnet_id = aws_subnet.pub-nginx.id
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
    subnet_id = aws_subnet.priv-tom.id
    route_table_id = aws_route_table.priv-RT.id
  
}
#Create a private route table and private subnet association for database
resource "aws_route_table_association" "private-association-db" {
    subnet_id = aws_subnet.priv-db.id
    route_table_id = aws_route_table.priv-RT.id
  
}
# Create a Security group
resource "aws_security_group" "ssh" {
    name = var.sg_name
    vpc_id = aws_vpc.Demo.id
  
}
#Add port 22,80,8080,3306 in inbound rule
resource "aws_vpc_security_group_ingress_rule" "inbound" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.sg_port[1]
    ip_protocol = "tcp"
    to_port = var.sg_port[1]

}
resource "aws_vpc_security_group_ingress_rule" "nginx" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.sg_port[2]
    ip_protocol = "tcp"
    to_port = var.sg_port[2]

}
resource "aws_vpc_security_group_ingress_rule" "Tomcat" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.sg_port[3]
    ip_protocol = "tcp"
    to_port = var.sg_port[3]

}
resource "aws_vpc_security_group_ingress_rule" "db" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.sg_port[4]
    ip_protocol = "tcp"
    to_port = var.sg_port[4]

}
#Add outbound rule
resource "aws_vpc_security_group_egress_rule" "outbound" {
    security_group_id = aws_security_group.ssh.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = var.sg_port[0]
    ip_protocol = "-1"
    to_port = var.sg_port[0]
  
}