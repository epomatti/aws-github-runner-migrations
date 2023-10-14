locals {
  prefix = "/${var.workload}/aurora"
}

resource "aws_ssm_parameter" "aurora_username" {
  name  = "${local.prefix}/username"
  type  = "String"
  value = var.aurora_username
}

resource "aws_ssm_parameter" "aurora_password" {
  name  = "${local.prefix}/password"
  type  = "SecureString"
  value = var.aurora_password
}

resource "aws_ssm_parameter" "aurora_endpoint" {
  name  = "${local.prefix}/endpoint"
  type  = "String"
  value = var.aurora_endpoint
}
