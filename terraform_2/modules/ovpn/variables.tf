variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Name of the environment (e.g., dev, test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to use"
  type        = string
}

variable "ami_id" {
  description = "AMI ID to launch EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"
}

variable "instance_type" {
  description = "Instance type for the EC2 spot instance"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small", "t3.medium", "t3.large"], var.instance_type)
    error_message = "Instance type must be one of: t3.micro, t3.small, t3.medium, t3.large"
  }
}

variable "availability_zone" {
  description = "The Availability Zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "subnet_cidr_block" {
  description = "Optional CIDR block to assign to the new subnet. If not provided, one will be generated."
  type        = string
  default     = null
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to access the instance via SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_udp_cidr" {
  description = "List of CIDR blocks allowed to access OpenVPN UDP port 1194"
  type        = list(string)
  default     = ["0.0.0.0/0"] # ⚠️ Open to the world — restrict in production
}

variable "allowed_http_cidr" {
  description = "List of CIDR blocks allowed to access HTTP (port 80)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_postgrey_cidr" {
  description = "List of CIDRs allowed to access Postgrey port (5324)"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # For public access (not recommended in production)
}

variable "allowed_https_cidr" {
  description = "List of CIDR blocks allowed to access HTTPS (port 443)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "root_volume_size" {
  type        = number
  default     = 8
  description = "Root volume size in GB"
}

variable "root_volume_type" {
  type        = string
  default     = "gp3"
  description = "Type of the root EBS volume"
}

