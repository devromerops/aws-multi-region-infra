variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment (e.g., development, production)"
  type        = string
  default     = "development"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "frontend_record_name" {
  description = "Frontend record name"
  type        = string
}


variable "aws_profile" {
  type        = string
  default     = "development"
}

variable "bucket_name" {
  type        = string
}

