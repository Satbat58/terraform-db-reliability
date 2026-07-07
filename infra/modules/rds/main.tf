# 1. RDS Security Group
resource "aws_security_group" "rds" {

  name   = "${local.name_prefix}-rds-sg"

  vpc_id = var.vpc_id

  ingress {

    from_port = 5432

    to_port = 5432

    protocol = "tcp"

    security_groups = [
      var.ecs_security_group_id
    ]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = merge(var.common_tags,{
    Name = "${local.name_prefix}-rds-sg"
  })

}

# 2. DB Subnet Group
resource "aws_db_subnet_group" "this" {

  name = "${local.name_prefix}-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-db-subnet-group"
  })

}

# 3. PostgreSQL Instance
resource "aws_db_instance" "this" {

  identifier = "${local.name_prefix}-postgres"

  engine = "postgres"

  engine_version = "16"

  instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage

  storage_type = "gp3"

  db_name = var.db_name

  username = var.db_username

  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection

  skip_final_snapshot = false

  multi_az = false

  storage_encrypted = true

  apply_immediately = true

  tags = merge(var.common_tags,{
    Name="${local.name_prefix}-postgres"
  })

}