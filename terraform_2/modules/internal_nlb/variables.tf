variable "nlb_name" {
  description = "Name of the NLB"
  type        = string
  default     = "cloudmasa-nlb"
}




variable "target_instance_ids" {
  description = "List of target instance IDs"
  type        = list(string)
}

variable "internal" {
  description = "Whether the NLB should be internal"
  type        = bool
  default     = false
}

variable "target_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "listener_port" {
  description = "Port for the NLB listener"
  type        = number
  default     = 80
}

variable "health_check_port" {
  description = "Port for health checks"
  type        = number
  default     = 80
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for NLB"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the NLB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the NLB will be created"
  type        = string
}
