terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-betta-test"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}