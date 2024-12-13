terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

locals {
  workload       = "migrations"
  aws_account_id = data.aws_caller_identity.current.account_id
  cluster_count  = var.create_application_cluster ? 1 : 0
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = local.workload
}

module "ec2_instance" {
  source        = "./modules/ec2-instance"
  vpc_id        = module.vpc.vpc_id
  subnet        = module.vpc.public_subnets[0]
  ami           = var.gh_runner_ami
  instance_type = var.gh_runner_instance_type
  user_data     = var.gh_runner_user_data
  az            = module.vpc.azs[0]
}

module "rds_mysql" {
  count          = local.cluster_count
  source         = "./modules/mysql"
  workload       = local.workload
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.private_subnets
  instance_class = var.rds_instance_class
  username       = var.rds_username
  password       = var.rds_password
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
  subnets  = module.vpc.public_subnets
  vpc_id   = module.vpc.vpc_id
}

module "ecs" {
  count                       = local.cluster_count
  source                      = "./modules/ecs"
  workload                    = local.workload
  subnets                     = module.vpc.public_subnets
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  ecr_repository_url          = module.ecr[0].repository_url
  ecs_task_execution_role_arn = module.iam_ecs_task_execution[0].ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam_ecs_task[0].ecs_task_role_arn
  target_group_arn            = module.elb[0].target_group_arn
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
  ssm_database_url_arn        = module.ssm[0].database_url_arn
}
