variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "prod-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "allowed_ssh_cidr" {
  description = "Allowed CIDR blocks for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_udp_cidr" {
  description = "Allowed CIDR blocks for UDP 1194"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access RDS (port 5432)"
  type        = list(string)
}
variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "prod-eks"
}

variable "cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.31"
}

variable "instance_types" {
  description = "EC2 instance types for EKS nodes"
  type        = list(string)
  default     = ["m5.large"]
}

# Add these new variables
variable "node_min_size" {
  description = "Minimum number of nodes in autoscaling group"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of nodes in autoscaling group"
  type        = number
  default     = 5
}

variable "node_desired_size" {
  description = "Desired number of nodes in autoscaling group"
  type        = number
  default     = 5
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}

# modules/rds/variables.tf

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
}


variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
}

variable "db_username" {
  description = "Initial database username (will be transformed if reserved)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_username) >= 3 && length(var.db_username) <= 16
    error_message = "Database username must be between 3 and 16 characters"
  }
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

#####################

variable "on_demand_instance_types" {
  description = "List of instance types for on_demand instances"
  type        = list(string)
  default     = ["m5.large"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 5
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}


##############


variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"  # You can override this in terraform.tfvars
}



variable "instance_type" {
  description = "The instance type for the on_demand request"
  type        = string
  default     = "t3.small"
}



#######################nlbandrout53

variable "nlb_name" {
  description = "Name for the Network Load Balancer"
  type        = string
  default     = "cloudmasa-nlb"
}

variable "nlb_target_port" {
  description = "Target port for the NLB"
  type        = number
  default     = 80
}

variable "nlb_listener_port" {
  description = "Listener port for the NLB"
  type        = number
  default     = 80
}

variable "nlb_health_check_port" {
  description = "Health check port for the NLB"
  type        = number
  default     = 80
}

variable "enable_nlb" {
  description = "Whether to create the NLB"
  type        = bool
  default     = true
}
