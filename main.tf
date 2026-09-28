data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AWS-VPC-Lab"
  }
}

resource "aws_vpc" "lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-lab-vpc"
    }
  )
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = var.public_subnet_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-public-subnet-1"
    }
  )
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-lab-igw"
    }
  )
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-public-rt"
    }
  )
}

resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = var.private_subnet_cidr

  tags = merge(
    {
      Name = "terraform-private-subnet-primary"
    }
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lab_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-private-rt"
    }
  )
}

resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = var.public_subnet_2_cidr

  tags = merge(
    local.common_tags,
    {
      Name = "terraform-public-subnet-2"
    }
  )
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}
