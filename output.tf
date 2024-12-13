output "rds_address" {
  value = var.create_application_cluster ? module.rds_mysql[0].address : null
}

output "elb_dns_name" {
  value = var.create_application_cluster ? module.elb[0].dns_name : null
}

output "github_runner_instance" {
  value = module.ec2-instance.instance
}
