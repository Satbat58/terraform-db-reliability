project_name = "hotel"

environment = "prod"

aws_region = "ap-south-1"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.3.0/24",
  "10.0.4.0/24"
]

availability_zones = [
  "ap-south-1a",
  "ap-south-1b"
]

container_image = "nginx:latest"

container_port = 80

cpu = 512

memory = 1024

desired_count = 2

execution_role_arn = "arn:aws:iam::194722408310:role/ecsTaskExecutionRole"

db_name = "hotel"

db_username = "postgres"

db_password = "ChangeMe123!"

db_instance_class = "db.t3.medium"

allocated_storage = 100

backup_retention_period = 30

deletion_protection = true