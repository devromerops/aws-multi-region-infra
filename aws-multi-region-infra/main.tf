provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

module "vpc" {
  source = "./modules/vpc"
  cidr_block = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  availability_zones = var.availability_zones
  environment = var.environment
}

module "security_groups" {
  source = "./modules/security_groups"
  environment = var.environment
  vpc_id = module.vpc.vpc_id
}

module "elb" {
  source = "./modules/elb"
  environment = var.environment
  subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.frontend_sg_id  # Aquí pasamos el frontend_sg_id al módulo elb
  vpc_id = module.vpc.vpc_id
}

module "route53" {
  source = "./modules/route53"
  environment = var.environment
  domain_name = var.domain_name
  frontend_record_name = var.frontend_record_name
  elb_dns_name = module.elb.dns_name
  elb_zone_id = module.elb.zone_id
}

module "s3" {
  source = "./modules/s3"
  environment = var.environment
  bucket_name = var.bucket_name
}

module "rds" {
  source = "./modules/rds"
  environment = var.environment
  subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.security_groups.rds_sg_id
  db_username = var.db_username
  db_password = var.db_password
  vpc_id = module.vpc.vpc_id
}
