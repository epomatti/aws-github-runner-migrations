aws_region = "us-east-2"

gh_runner_ami           = "ami-036841078a4b68e14"
gh_runner_instance_type = "t3.medium"
gh_runner_user_data     = "ubuntu-nodejs.sh" # ubuntu-nodejs.sh, ubuntu-docker.sh

create_application_cluster = false

rds_instance_class = "db.t4g.micro"
rds_username       = "mysqladmin"
rds_password       = "p4ssw0rd"

ecs_task_cpu    = 512
ecs_task_memory = 1024
