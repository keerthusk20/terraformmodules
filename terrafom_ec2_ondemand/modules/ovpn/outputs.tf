output "instance_public_ip" {
  value = aws_instance.ec2_on_demand.public_ip
}

output "ssh_command" {
  value = "ssh -i ec2-key.pem ec2-user@${aws_instance.ec2_on_demand.public_ip}"
}

output "subnet_cidr" {
  value = aws_subnet.public.cidr_block
}

output "vpc_id" {
  value = var.vpc_id
}

output "instance_id" {
  description = "The ID of the created EC2 on_demand instance"
  value       = aws_instance.ec2_on_demand.id
}
