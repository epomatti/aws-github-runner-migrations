output "address" {
  value = aws_db_instance.default.address
}

locals {
  username = aws_db_instance.default.username
  address  = aws_db_instance.default.address
  db_name  = aws_db_instance.default.db_name
}

output "database_url" {
  value     = "mysql://${local.username}:${var.password}@${local.address}:3306/${local.db_name}"
  sensitive = true
}
