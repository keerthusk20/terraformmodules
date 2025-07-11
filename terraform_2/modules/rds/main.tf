resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_parameter_group" "postgres" {
  name   = "${var.environment}-postgres-params"
  family = "postgres14"

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1000"
  }

  parameter {
    name  = "rds.log_retention_period"
    value = "10080"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  tags = {
    Name        = "${var.environment}-postgres-params"
    Environment = var.environment
  }
}

resource "aws_db_instance" "main" {
  identifier             = "${var.environment}-db"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  engine_version         = "14"
  username               = local.db_username
  password               = var.db_password
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  vpc_security_group_ids = var.security_group_ids
  parameter_group_name   = aws_db_parameter_group.postgres.name
  skip_final_snapshot    = true

  monitoring_interval     = 60
  monitoring_role_arn     = var.monitoring_role_arn

  deletion_protection     = false
  multi_az                = true
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"
  copy_tags_to_snapshot   = true
  auto_minor_version_upgrade = true
  iam_database_authentication_enabled = true
  ca_cert_identifier      = "rds-ca-rsa2048-g1"

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  tags = {
    Name        = "${var.environment}-db"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [password]
  }
}

locals {
  reserved_postgres_usernames = ["admin", "postgres", "rdsadmin", "master", "root", "rdsroot"]
  db_username = contains(local.reserved_postgres_usernames, lower(var.db_username)) ? "${var.db_username}_user" : var.db_username
}