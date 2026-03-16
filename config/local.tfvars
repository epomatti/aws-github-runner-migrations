# Project
aws_region = "sa-east-1"

# GitHub Runner
gh_runner_ami             = "ami-07b9c29a7d77fdcee" # Ubuntu Pro 24.04 LTS
gh_runner_instance_type   = "t3.small"
gh_runner_user_data       = "ubuntu_upgrade.sh"
gh_runner_token           = "github_pat_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
gh_runner_usg_cis_profile = "cis_level1_server"

# RDS
rds_create_instance = false
rds_instance_class  = "db.t4g.micro"
rds_username        = "mysqladmin"
rds_password        = "p4ssw0rd"
rds_engine          = "mysql"
rds_engine_version  = "8.4.7"

# Application Cluster
create_application_cluster = false
ecs_task_cpu               = 512
ecs_task_memory            = 1024
