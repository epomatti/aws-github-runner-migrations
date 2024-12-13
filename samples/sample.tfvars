aws_region = "us-east-2"

gh_runner_ami           = "ami-0560690593473ded1"
gh_runner_instance_type = "t4g.micro"
gh_runner_user_data     = "ubuntu-nodejs.sh" # ubuntu-nodejs.sh, ubuntu-docker.sh

rds_instance_class = "db.t4g.micro"
rds_username       = "mysqladmin"
rds_password       = "p4ssw0rd"

ecs_task_cpu    = 512
ecs_task_memory = 1024
