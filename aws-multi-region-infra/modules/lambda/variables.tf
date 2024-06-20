variable "environment" {
  description = "Environment (e.g., development, production)"
  type        = string
}

variable "db_endpoint" {
  description = "RDS endpoint"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for Lambda"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for Lambda"
  type        = string
}
