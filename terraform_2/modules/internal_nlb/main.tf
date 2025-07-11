# main.tf (Updated)
module "nlb" {
  source = "./modules/internal_nlb"

  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets # For internal NLB

  # No target_instance_ids needed for EKS
  nlb_name          = "eks-${var.cluster_name}-nlb"
  internal          = true # Typically internal for EKS
  target_port       = 80
  listener_port     = 80
  health_check_port = 80

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# Route53 Private Hosted Zone
resource "aws_route53_zone" "private" {
  name = "int.cloudmasa.com"

  vpc {
    vpc_id = var.vpc_id
  }

  tags = merge(
    var.tags,
    {
      Name = "int.cloudmasa.com"
    }
  )
}

# Wildcard record for the hosted zone
resource "aws_route53_record" "wildcard" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "*.int.cloudmasa.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.nlb.dns_name]
}

# Specific records for services
resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "argocd.int.cloudmasa.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.nlb.dns_name]
}

resource "aws_route53_record" "velero" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "velero.int.cloudmasa.com"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.nlb.dns_name]
}