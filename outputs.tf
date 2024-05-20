
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "frontend_ec2_id" {
  value = module.frontend_ec2.instance_id
}

output "backend_ec2_id" {
  value = module.backend_ec2.instance_id
}

output "rds_endpoint" {
  value = module.rds.endpoint
}
