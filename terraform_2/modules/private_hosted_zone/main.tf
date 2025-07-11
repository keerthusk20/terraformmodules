module "private_hosted_zone" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "int.cloudmasa.com" = {
      comment = "Private hosted zone for internal Cloudmasa services"
      vpc = [
        {
          vpc_id = var.vpc_id
        }
      ]
    }
  }

  tags = var.tags
}

resource "aws_lb" "internal_nlb" {
  name               = "int-cloudmasa-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.private_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name = "int-cloudmasa-nlb"
  })
}

resource "aws_route53_record" "nlb_alias" {
  zone_id = module.private_hosted_zone.route53_zone_zone_id["int.cloudmasa.com"]
  name    = "*.int.cloudmasa.com"
  type    = "A"

  alias {
    name                   = aws_lb.internal_nlb.dns_name
    zone_id                = aws_lb.internal_nlb.zone_id
    evaluate_target_health = true
  }
}



# Example target group for services
resource "aws_lb_target_group" "services" {
  name        = "int-cloudmasa-services"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }

  tags = var.tags
}

# Example listener for the NLB
resource "aws_lb_listener" "services" {
  load_balancer_arn = aws_lb.internal_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.services.arn
  }
}



###
resource "aws_route53_record" "argocd_record" {
  zone_id = module.private_hosted_zone.route53_zone_zone_id["int.cloudmasa.com"]
  name    = "argocd.int.cloudmasa.com"
  type    = "A"

  alias {
    name                   = aws_lb.internal_nlb.dns_name
    zone_id                = aws_lb.internal_nlb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "kyverno_record" {
  zone_id = module.private_hosted_zone.route53_zone_zone_id["int.cloudmasa.com"]
  name    = "kyverno.int.cloudmasa.com"
  type    = "A"

  alias {
    name                   = aws_lb.internal_nlb.dns_name
    zone_id                = aws_lb.internal_nlb.zone_id
    evaluate_target_health = true
  }
}