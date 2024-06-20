terraform {
  required_version = ">= 1.5.7"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region

  # Utiliza el perfil por defecto en ~/.aws/credentials
  profile = var.aws_profile

  # Para usar roles de IAM (ideal para instancias EC2 o ECS):
  #assume_role {
   # role_arn = "arn:aws:iam::123456789012:role/MyTerraformRole"
  #}
}
