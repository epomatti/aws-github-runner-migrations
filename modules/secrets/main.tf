resource "aws_secretsmanager_secret" "github_token" {
  name                    = "github_token"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "github_token_v1" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = var.github_token
}
