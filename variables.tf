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

### ECS ###
variable "ecs_task_cpu" {
  type = number
}

variable "ecs_task_memory" {
  type = number
}
