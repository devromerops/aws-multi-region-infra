resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "13.15"
  instance_class       = "db.t3.micro"
  identifier           = "mydb"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  multi_az             = true
  publicly_accessible  = false
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  backup_retention_period = 7
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-subnet-group"
  subnet_ids = var.subnet_ids
}

output "db_instance_endpoint" {
  value = aws_db_instance.main.endpoint
}
