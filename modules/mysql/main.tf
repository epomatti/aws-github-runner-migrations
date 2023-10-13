resource "aws_db_instance" "default" {
  identifier     = "rds-${var.workload}"
  db_name        = "mysqldb"
  engine         = "mysql"
  engine_version = "8.0"
  username       = var.username
  password       = var.password

  multi_az = var.multi_az

  blue_green_update {
    enabled = false
  }

  db_subnet_group_name = aws_db_subnet_group.default.name
  publicly_accessible  = false

  instance_class        = var.instance_class
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  ca_cert_identifier    = "rds-ca-rsa2048-g1"

  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.mysql.id]

  apply_immediately = true

  deletion_protection      = false
  skip_final_snapshot      = true
  delete_automated_backups = true
}

resource "aws_db_subnet_group" "default" {
  name       = "rds-subnets-${var.workload}"
  subnet_ids = var.subnets
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "mysql" {
  name        = "rds-${var.workload}"
  description = "Allow TLS inbound traffic to RDS MySQL"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-rds-${var.workload}"
  }
}

resource "aws_security_group_rule" "mysql_ingress" {
  description       = "Allows MySQL connections"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  security_group_id = aws_security_group.mysql.id
}
