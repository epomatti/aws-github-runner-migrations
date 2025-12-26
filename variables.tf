variable "aws_region" {
  type    = string
  default = "us-east-2"
}

### GitHub Runner ###
variable "gh_runner_ami" {
  type = string
}

variable "gh_runner_instance_type" {
  type = string
}

variable "gh_runner_user_data" {
  type = string
}

variable "gh_runner_token" {
  type      = string
  sensitive = true
}

variable "gh_runner_usg_cis_profile" {
  type = string
}

### Application Cluster ###
variable "create_application_cluster" {
  type = bool
}

### RDS for MySQL ###

variable "rds_instance_class" {
  type = string
}

variable "rds_username" {
  type = string
}

variable "rds_password" {
  type      = string
  sensitive = true
}

variable "rds_engine" {
  type = string
}

variable "rds_engine_version" {
  type = string
}

### ECS ###
variable "ecs_task_cpu" {
  type = number
}

variable "ecs_task_memory" {
  type = number
}
