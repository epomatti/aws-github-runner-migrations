output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

output "availability_zones" {
  value = local.availability_zones
}

output "primary_az" {
  value = local.availability_zones[0]
}

output "primary_public_subnet" {
  value = aws_subnet.public1.id
}

output "primary_private_subnet" {
  value = aws_subnet.private1.id
}

output "public_subnets" {
  value = [aws_subnet.public1.id, aws_subnet.public2.id]
}

output "private_subnets" {
  value = [aws_subnet.private1.id, aws_subnet.private2.id]
}
