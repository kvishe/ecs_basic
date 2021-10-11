resource "aws_alb" "ec2_load_balancer" {
  name            = "${var.project_code}-${var.environment}-alb"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = [aws_subnet.pub_subnet_a.id, aws_subnet.pub_subnet_c.id]

  tags = {
    Name        = "${var.project_code}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.project_code}-${var.environment}-tg"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name        = "${var.project_code}-${var.environment}-tg"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
  depends_on = [aws_alb.ec2_load_balancer]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.ec2_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project_code}-${var.environment}-alb-sg"
  description = "Allow inbound traffic to ALB"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow 80 to ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 443 to ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_code}-${var.environment}-alb-sg"
    Environment = var.environment
    Project     = var.project_code
    Manager     = var.project_mgr
  }
}