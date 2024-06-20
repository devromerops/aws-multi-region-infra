output "db_instance_id" {
  value = aws_db_instance.main.id
}

output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_subnet_group" {
  value = aws_db_subnet_group.main.name
}
