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
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.network.private_subnet_id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.network.internet_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.network.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.network.private_route_table_id
}

output "web_instance_id" {
  description = "ID of the web EC2 instance"
  value       = aws_instance.web.id
}

output "web_public_ip" {
  description = "Public IPv4 address of the web EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "URL of the Terraform web server"
  value       = "http://${aws_instance.web.public_ip}"
}
