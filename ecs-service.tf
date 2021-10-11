resource "aws_ecs_service" "ecs_service" {
  name                = lower(join("-", [var.project_code, var.environment]))
  cluster             = aws_ecs_cluster.ecs_cluster.id
  launch_type         = "EC2"
  task_definition     = aws_ecs_task_definition.task_definition.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  network_configuration {
    subnets          = [aws_subnet.pvt_subnet_a.id, aws_subnet.pvt_subnet_c.id]
    security_groups  = [aws_security_group.ec2_server_sg.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_port   = 80
    container_name   = "test-app"
  }
}
