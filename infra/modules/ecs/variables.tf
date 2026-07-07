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

variable "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS"
  type        = list(string)
}

variable "container_image" {
  description = "Docker image"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "Task CPU"
  type        = number
}

variable "memory" {
  description = "Task Memory"
  type        = number
}

variable "desired_count" {
  description = "Desired ECS tasks"
  type        = number
}

variable "common_tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

variable "execution_role_arn" {
  description = "IAM Execution Role ARN for ECS Task"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
}