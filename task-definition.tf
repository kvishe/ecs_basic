resource "aws_ecs_task_definition" "task_definition" {
  family                   = "${var.project_code}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "test-app",
    "image": "nginx",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "memory": 300
  }
]
DEFINITION
}
