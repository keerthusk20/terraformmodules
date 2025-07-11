output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_name" {
  value = module.vpc.vpc_name
}



output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority
}


# output "db_endpoint" {
#   description = "The RDS instance endpoint"
#   value       = module.rds.db_endpoint
#   sensitive   = true
# }

# output "db_identifier" {
#   description = "The RDS instance identifier"
#   value       = module.rds.db_identifier
# }

# output "db_instance_arn" {
#   description = "The ARN of the RDS instance"
#   value       = module.rds.db_instance_arn
# }



output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
} 

output "eks_node_role_arn" {
  value = module.eks.node_role_arn
}


################
output "instance_public_ip" {
  value = module.spot_instance.instance_public_ip
}

output "ssh_command" {
  value = module.spot_instance.ssh_command
}

###


