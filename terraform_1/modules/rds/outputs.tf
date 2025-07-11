output "db_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.main.endpoint
}

output "db_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.main.identifier
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.main.arn
}