
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].cidr_block
}

output "private_subnets" {
  value = aws_subnet.private[*].cidr_block
}

output "vpc_id" {
  value = aws_vpc.main.id
}