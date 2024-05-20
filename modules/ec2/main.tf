resource "aws_instance" "ec2_instance" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  security_groups = var.security_group_ids
}
