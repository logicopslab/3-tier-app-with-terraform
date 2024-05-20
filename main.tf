provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "frontend_ec2" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  ami = "ami-01cd4de4363ab6ee8"
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.vpc.frontend_sg_id]
}

module "backend_ec2" {
  source = "./modules/ec2"
  instance_type = "t2.micro"
  ami = "ami-01cd4de4363ab6ee8"
  subnet_id = module.vpc.private_subnet_ids[0]
  security_group_ids = [module.vpc.backend_sg_id]
}

module "rds" {
  source = "./modules/rds"
  subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.vpc.database_sg_id
  db_username = "admin"
  #db_password = aws_secretsmanager_secret_version.db_password.secret_string
  db_password = "${file("../rds_pass.txt")}"
}

resource "aws_secretsmanager_secret" "db_password" {
  name = "rds_db_password"
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id = aws_secretsmanager_secret.db_password.id
  secret_string = jsonencode({
    password = "my-secure-password"
  })
}
