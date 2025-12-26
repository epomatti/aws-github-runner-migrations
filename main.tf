terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  workload       = "migrations"
  aws_account_id = data.aws_caller_identity.current.account_id
  cluster_count  = var.create_application_cluster ? 1 : 0
}

module "network" {
  source     = "./modules/network"
  aws_region = var.aws_region
  workload   = local.workload
}

module "iam_github_runner" {
  source = "./modules/iam/github_runner"
}

module "parameters" {
  source       = "./modules/parameters"
  github_token = var.gh_runner_token
}

module "github_runner_instance" {
  source              = "./modules/instances/github_runner"
  vpc_id              = module.network.vpc_id
  subnet              = module.network.primary_public_subnet
  ami                 = var.gh_runner_ami
  instance_type       = var.gh_runner_instance_type
  user_data           = var.gh_runner_user_data
  az                  = module.network.primary_az
  vpc_cidr_block      = module.network.vpc_id
  instance_profile_id = module.iam_github_runner.instance_profile_id

  depends_on = [module.iam_github_runner, module.parameters]
}

module "rds_mysql" {
  count             = local.cluster_count
  source            = "./modules/mysql"
  workload          = local.workload
  vpc_id            = module.network.vpc_id
  subnets           = module.network.private_subnets
  instance_class    = var.rds_instance_class
  username          = var.rds_username
  password          = var.rds_password
  availability_zone = module.network.primary_az
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
}

module "ecr" {
  count  = local.cluster_count
  source = "./modules/ecr"
}

module "iam_ecs_task_execution" {
  count  = local.cluster_count
  source = "./modules/iam/ecs/execution"
}

module "iam_ecs_task" {
  count          = local.cluster_count
  source         = "./modules/iam/ecs/task"
  aws_account_id = local.aws_account_id
  aws_region     = var.aws_region
}

module "ssm" {
  count        = local.cluster_count
  source       = "./modules/ssm"
  database_url = module.rds_mysql[0].database_url
}

module "elb" {
  count    = local.cluster_count
  source   = "./modules/elb"
  workload = local.workload
  subnets  = module.network.public_subnets
  vpc_id   = module.network.vpc_id
}

module "ecs" {
  count                       = local.cluster_count
  source                      = "./modules/ecs"
  workload                    = local.workload
  subnets                     = module.network.public_subnets
  vpc_id                      = module.network.vpc_id
  aws_region                  = var.aws_region
  ecr_repository_url          = module.ecr[0].repository_url
  ecs_task_execution_role_arn = module.iam_ecs_task_execution[0].ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam_ecs_task[0].ecs_task_role_arn
  target_group_arn            = module.elb[0].target_group_arn
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
  ssm_database_url_arn        = module.ssm[0].database_url_arn
}
