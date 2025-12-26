resource "aws_ssm_parameter" "github_token" {
  name  = "github_token"
  type  = "SecureString"
  value = var.github_token
}
