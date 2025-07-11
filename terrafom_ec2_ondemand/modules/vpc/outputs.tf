output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_name" {
  value = module.vpc.name
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "security_group_id" {
  value = aws_security_group.vpc_sg.id
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}
