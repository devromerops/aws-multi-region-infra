variable "rest_api_name" {
  description = "The name of the API Gateway REST API"
  type        = string
}

variable "resource_path_part" {
  description = "The path part of the API Gateway resource"
  type        = string
}

variable "lambda_integration_uri" {
  description = "The URI of the Lambda function to integrate with"
  type        = string
}
