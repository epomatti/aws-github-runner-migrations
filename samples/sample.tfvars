# Project
aws_region = "us-east-2"

# GitHub Runner
gh_runner_ami           = "ami-0f5fcdfbd140e4ab7"
gh_runner_instance_type = "t3.medium"
gh_runner_user_data     = "ubuntu-runner.sh"
gh_runner_token         = ""

# RDS
rds_instance_class = "db.t4g.micro"
rds_username       = "mysqladmin"
rds_password       = "p4ssw0rd"
rds_engine         = "mysql"
rds_engine_version = "8.4.7"

# Application Cluster
create_application_cluster = false
ecs_task_cpu               = 512
ecs_task_memory            = 1024
