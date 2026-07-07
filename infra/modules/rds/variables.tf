variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security Group ID of ECS"
  type        = string
}

variable "db_name" {
  description = "Database Name"
  type        = string
}

variable "db_username" {
  description = "Database Username"
  type        = string
}

variable "db_password" {
  description = "Database Password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS Instance Class"
  type        = string
}

variable "allocated_storage" {
  description = "Storage Size"
  type        = number
}

variable "backup_retention_period" {
  description = "Backup Retention Days"
  type        = number
}

variable "deletion_protection" {
  description = "Deletion Protection"
  type        = bool
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
  default     = {}
}