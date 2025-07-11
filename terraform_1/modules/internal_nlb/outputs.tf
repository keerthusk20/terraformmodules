output "nlb_dns_name" {
  description = "DNS name of the NLB"
  value       = aws_lb.nlb.dns_name
}

output "nlb_arn" {
  description = "ARN of the NLB"
  value       = aws_lb.nlb.arn
}

output "nlb_zone_id" {
  description = "Zone ID of the NLB"
  value       = aws_lb.nlb.zone_id
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.nlb_tg.arn
}

output "private_hosted_zone_id" {
  description = "ID of the private hosted zone"
  value       = aws_route53_zone.private.zone_id
}

output "private_hosted_zone_name" {
  description = "Name of the private hosted zone"
  value       = aws_route53_zone.private.name
}