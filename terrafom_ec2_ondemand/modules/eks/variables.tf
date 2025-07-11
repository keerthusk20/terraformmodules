variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "VPC ID where cluster will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

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

variable "endpoint_private_access" {
  description = "Enable private access to cluster endpoint"
  type        = bool
  default     = false
}

variable "endpoint_public_access" {
  description = "Enable public access to cluster endpoint"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "aws_auth_users" {
  description = "List of IAM users to add to aws-auth configmap"
  type        = list(any)
  default     = []
}
