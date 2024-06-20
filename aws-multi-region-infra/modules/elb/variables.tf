variable "environment" {
  description = "Environment (e.g., development, production)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
