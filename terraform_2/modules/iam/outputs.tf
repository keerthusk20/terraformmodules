output "rds_monitoring_role_arn" {
  description = "ARN of the RDS monitoring role"
  value       = aws_iam_role.rds_monitoring.arn
}

output "db_admin_role_arn" {
  description = "ARN of the DB admin role"
  value       = aws_iam_role.db_admin.arn
}


