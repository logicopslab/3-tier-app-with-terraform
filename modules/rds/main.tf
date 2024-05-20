resource "aws_db_subnet_group" "main" {
  name = "main-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "main" {
  identifier = "main-db"
  engine = "mysql"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  username = var.db_username
  password = var.db_password
  skip_final_snapshot = true
}
