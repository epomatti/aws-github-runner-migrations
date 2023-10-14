output "rds_address" {
  value = module.rds_mysql.address
}

output "elb_dns_name" {
  value = module.elb.dns_name
}
