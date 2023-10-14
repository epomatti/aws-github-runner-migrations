output "rds_address" {
  value = module.rds_mysql.address
}

output "github_runner_private_ip" {
  value = module.ec2-instance.private_ip
}
