output "instance_public_ip" {
  value = aws_spot_instance_request.ec2_spot.public_ip
}

output "ssh_command" {
  value = "ssh -i ec2-key.pem ec2-user@${aws_spot_instance_request.ec2_spot.public_ip}"
}

output "subnet_cidr" {
  value = aws_subnet.public.cidr_block
}

output "vpc_id" {
  value = var.vpc_id
}

output "instance_id" {
  description = "The ID of the created EC2 spot instance"
  value       = aws_spot_instance_request.ec2_spot.spot_instance_id
}
