resource "aws_launch_configuration" "ecs_launch_config" {
    image_id             = var.ec2_amis["ecs"]
    iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name
    security_groups      = [aws_security_group.ec2_server_sg.id]
    instance_type        = var.instance_types["ec2"]
    key_name             = "dev-test"
    user_data            = "#!/bin/bash\necho ECS_CLUSTER=${var.project_code}-${var.environment}-cluster >> /etc/ecs/ecs.config"
}

resource "aws_autoscaling_group" "ecs_asg" {
    name                      = "${var.project_code}-${var.environment}-asg"
    vpc_zone_identifier       = [aws_subnet.pub_subnet_a.id, aws_subnet.pub_subnet_c.id]
    launch_configuration      = aws_launch_configuration.ecs_launch_config.name

    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 3
    health_check_grace_period = 300
    health_check_type         = "EC2"
}

#Security Group for EC2 Server
resource "aws_security_group" "ec2_server_sg" {
  name        = "${var.project_code}-${var.environment}-ec2-sg"
  description = "Security Group for ${var.project_code}-${var.environment} ec2 Servers"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    security_groups  = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_code}-${var.environment}-ec2-sg"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}
