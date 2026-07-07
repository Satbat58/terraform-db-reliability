# 1 CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs" {

  name              = "/ecs/${local.name_prefix}"

  retention_in_days = 7

  tags = merge(var.common_tags, {
    Name = "${local.name_prefix}-logs"
  })

}

# 2 ALB Security Group
resource "aws_security_group" "alb" {

  name   = "${local.name_prefix}-alb-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = 80

    to_port = 80

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-alb-sg"
  })

}

# 3 ECS Security Group
resource "aws_security_group" "ecs" {

  name   = "${local.name_prefix}-ecs-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = var.container_port

    to_port = var.container_port

    protocol = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-ecs-sg"
  })

}

# 4 Application Load Balancer
resource "aws_lb" "this" {

  name = "${local.name_prefix}-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = var.public_subnet_ids

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-alb"
  })

}

# 5 Target Group
resource "aws_lb_target_group" "ecs" {

  name = "${local.name_prefix}-tg"

  port = var.container_port

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = "/"

    matcher = "200"

  }

}

# 6 Listener
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.ecs.arn

  }

}

# 7 ECS Cluster
resource "aws_ecs_cluster" "this" {

  name = "${local.name_prefix}-cluster"

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-cluster"
  })

}

# 8 Task Definition
resource "aws_ecs_task_definition" "this" {

  family = "${local.name_prefix}-task"

  network_mode = "awsvpc"

  requires_compatibilities = ["FARGATE"]

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = var.container_image

      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"

        }
      }
    }
  ])

}

# 9 ECS Service
resource "aws_ecs_service" "this" {

  name = "${local.name_prefix}-service"

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = var.private_subnet_ids

    security_groups = [
      aws_security_group.ecs.id
    ]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.ecs.arn

    container_name = "app"

    container_port = var.container_port

  }

  depends_on = [
    aws_lb_listener.http
  ]

}

