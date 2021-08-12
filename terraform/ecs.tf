resource "aws_ecs_cluster" "ping" {
  name = "ping"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                        = "service"
  network_mode                  = "awsvpc"
  requires_compatibilities      = ["FARGATE"]
  cpu                           = 512
  memory                        = 2048
#   execution_role_arn            = aws_iam_role.ecs_role.arn
  container_definitions         = jsonencode([
    {
      name      = "nginx-app"
      # image     = "markokole/nginx:latest"
      image     = "nginx:latest"
      cpu       = 512
      memory    = 2048
      essential = true  # if true and if fails, all other containers fail. Must have at least one essential
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  
#   tags = {
#     Name = var.name
#   }
}

resource "aws_ecs_service" "service" {
  name              = "service"
  cluster           = aws_ecs_cluster.ping.id
  task_definition   = aws_ecs_task_definition.task.id
  desired_count     = 1
  launch_type       = "FARGATE"
  platform_version  = "LATEST" # only FARGATE
  # launch_type       = "EC2"
#   service_registries {
#     registry_arn    = aws_service_discovery_service.public_apps[each.key].arn
#     container_name  = "${each.key}-app"
#   }

  network_configuration {
    assign_public_ip  = true # only FARGATE
    security_groups   = [aws_security_group.sg.id]
    subnets           = [aws_subnet.subnet.id]
  }
  lifecycle {
    ignore_changes = [task_definition]
  }

  # tags = {
  #   Name = var.name
  # }
}