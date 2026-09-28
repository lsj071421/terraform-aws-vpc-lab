variable "aws_region" {
  description = "AWS region used for the Terraform lab"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
}

variable "environment" {
  description = "Environment tag"
  type        = string
}

variable "public_subnets" {
  description = "CIDR blocks for the public subnets"
  type        = map(string)
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
}
