data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "AWS-VPC-Lab"
  }
}

module "network" {
  source = "./modules/network"

  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnet_cidr = var.private_subnet_cidr
  environment         = var.environment
}
