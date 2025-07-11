variable "vpc_id" {
  description = "The VPC ID where the private hosted zone should be associated"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the NLB"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection for the NLB"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}