output "private_ip" {
  value = aws_instance.default.private_ip
}

output "instance" {
  value = aws_instance.default.id
}
