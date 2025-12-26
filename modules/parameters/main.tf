resource "aws_ssm_parameter" "github_token" {
  name  = "github_token"
  type  = "SecureString"
  value = var.github_token
}

resource "aws_ssm_parameter" "s3bucket" {
  name  = "s3bucket"
  type  = "String"
  value = var.s3bucket
}

resource "aws_ssm_parameter" "usg_cis_profile" {
  name  = "usg_cis_profile"
  type  = "String"
  value = var.usg_cis_profile
}
