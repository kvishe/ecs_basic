resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_code}-${var.environment}-cluster"

  tags = {
    Name        = upper(join("-", [var.project_code, var.environment, "ECS"]))
    Environment = var.environment
    Manager     = var.project_mgr
    Project     = var.project_code
  }
}