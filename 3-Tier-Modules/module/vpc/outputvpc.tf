output "sg_id" {
    value = aws_security_group.ssh.id
  
}
output "pub_subnet_id" {
    value = aws_subnet.pub-nginx.id
  
}
output "priv1_subnet_id" {
    value = aws_subnet.priv-tom.id
  
}
output "priv_subnet_id" {
    value = aws_subnet.priv-db.id
  
}