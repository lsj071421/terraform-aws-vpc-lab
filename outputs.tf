output "aws_region" {
  description = "AWS region hosting the Terraform lab"
  value       = data.aws_region.current.region
}

output "caller_arn" {
  description = "AWS identity used by Terraform"
  value       = data.aws_caller_identity.current.arn
}

output "vpc_id" {
  description = "ID of the Terraform lab VPC"
  value       = aws_vpc.lab_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"

  value = {
    for name, subnet in aws_subnet.public :
    name => subnet.id
  }
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private_subnet_1.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.lab_igw.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_rt.id
}
