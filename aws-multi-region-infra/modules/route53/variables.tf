variable "environment" {
  description = "Environment (e.g., development, production)"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "frontend_record_name" {
  description = "Frontend record name"
  type        = string
}

variable "elb_dns_name" {
  description = "DNS name of the Load Balancer"
  type        = string
}

variable "elb_zone_id" {
  description = "Zone ID of the Load Balancer"
  type        = string
}
