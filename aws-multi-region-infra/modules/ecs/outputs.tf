output "ecs_cluster_id" {
  value = aws_ecs_cluster.frontend.id
}

output "ecs_service_name" {
  value = aws_ecs_service.frontend_service.name
}
