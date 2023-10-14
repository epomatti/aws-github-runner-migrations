terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.21.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "migrations"
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = local.workload
}

module "ec2-instance" {
  source        = "./modules/ec2-instance"
  vpc_id        = module.vpc.vpc_id
  subnet        = module.vpc.public_subnets[0]
  ami           = var.gh_runner_ami
  instance_type = var.gh_runner_instance_type
}

module "rds_mysql" {
  source         = "./modules/mysql"
  workload       = local.workload
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.private_subnets
  multi_az       = var.rds_multi_az
  instance_class = var.rds_instance_class
  username       = var.rds_username
  password       = var.rds_password
}

module "ecr" {
  source   = "./modules/ecr"
  workload = local.workload
}

module "ecs" {
  source                      = "./modules/ecs"
  workload                    = local.workload
  subnets                     = module.vpc.application_subnets
  vpc_id                      = module.vpc.vpc_id
  aws_region                  = var.aws_region
  ecr_repository_url          = module.ecr.repository_url
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn           = module.iam.ecs_task_role_arn
  target_group_arn            = module.elb.target_group_arn
  task_cpu                    = var.ecs_task_cpu
  task_memory                 = var.ecs_task_memory
}