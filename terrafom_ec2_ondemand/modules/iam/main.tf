data "aws_caller_identity" "current" {}

resource "aws_iam_role" "rds_monitoring" {
  name = "${var.environment}-rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_policy" "rds_secrets_manager" {
  name        = "${var.environment}-rds-secrets-manager"
  description = "Policy for RDS secrets manager access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.environment}/rds/*"
      },
    ]
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role" "db_admin" {
  name = "${var.environment}-db-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithSAML"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/MySSOProvider"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "db_admin_secrets" {
  role       = aws_iam_role.db_admin.name
  policy_arn = aws_iam_policy.rds_secrets_manager.arn
}