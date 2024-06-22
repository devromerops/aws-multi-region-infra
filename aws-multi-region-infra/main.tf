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

module "iam" {
  source = "./modules/iam"
}

resource "aws_instance" "example" {
  ami                    = "ami-12345678"
  instance_type          = "t2.micro"
  iam_instance_profile   = module.iam.ec2_ssm_instance_profile

  tags = {
    Name = "example-instance"
  }
}

module "nat" {
  source          = "./modules/nat"
  public_subnet_id = element(module.vpc.public_subnet_ids, 0)
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc_id
}

resource "aws_ecs_task_definition" "example" {
  family                   = "example"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name  = "example"
      image = "amazon/amazon-ecs-sample"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_lambda_function" "example" {
  function_name = "example_lambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  vpc_config {
    subnet_ids         = module.vpc.private_subnet_ids
    security_group_ids = [aws_security_group.lambda.id]
  }
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.example_deployment.invoke_url
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
