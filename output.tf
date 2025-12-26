output "rds_address" {
  value = var.create_application_cluster ? module.rds_mysql[0].address : null
}

output "elb_dns_name" {
  value = var.create_application_cluster ? module.elb[0].dns_name : null
}

output "github_runner_instance_id" {
  value = module.github_runner_instance.instance_id
}

output "ssm_start_session_command" {
  value = "aws ssm start-session --target ${module.github_runner_instance.instance_id}"
}
