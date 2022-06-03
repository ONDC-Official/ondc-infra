output "default_vpc" {
  value = aws_default_vpc.default_vpc.id
}

output "default_subnet" {
  value = aws_default_subnet.default_subnet.id
}

output "aws_default_security_group" {
  value = aws_default_security_group.default.id
}