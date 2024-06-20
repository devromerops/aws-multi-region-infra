resource "aws_ecs_cluster" "frontend" {
  name = "${var.environment}-frontend-cluster"
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "frontend_service" {
  name            = "${var.environment}-frontend-service"
  cluster         = aws_ecs_cluster.frontend.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets         = [for subnet in var.subnet_ids : subnet]
    security_groups = [var.security_group_id]
  }
}
