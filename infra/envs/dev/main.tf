# Network Module
module "network" {

  source = "../../modules/network"

  project_name = var.project_name
  environment = var.environment

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = var.availability_zones

  common_tags = local.common_tags

}

# ECS Module
module "ecs" {

  source = "../../modules/ecs"

  project_name = var.project_name
  environment = var.environment

  vpc_id = module.network.vpc_id

  public_subnet_ids = module.network.public_subnet_ids

  private_subnet_ids = module.network.private_subnet_ids

  container_image = var.container_image

  container_port = var.container_port

  cpu = var.cpu

  memory = var.memory

  desired_count = var.desired_count

  execution_role_arn = var.execution_role_arn

  aws_region = var.aws_region

  common_tags = local.common_tags

}

# RDS Module
module "rds" {

  source = "../../modules/rds"

  project_name = var.project_name

  environment = var.environment

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids

  ecs_security_group_id = module.ecs.ecs_security_group_id

  db_name = var.db_name

  db_username = var.db_username

  db_password = var.db_password

  db_instance_class = var.db_instance_class

  allocated_storage = var.allocated_storage

  backup_retention_period = var.backup_retention_period

  deletion_protection = var.deletion_protection

  common_tags = local.common_tags

}

