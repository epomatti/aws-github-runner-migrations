locals {
  prefix = "/prisma"
}

resource "aws_ssm_parameter" "database_url" {
  name  = "${local.prefix}/database-url"
  type  = "SecureString"
  value = var.database_url
}
