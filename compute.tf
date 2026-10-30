resource "aws_security_group" "web" {
  name        = "terraform-web-sg"
  description = "Security group for Terraform EC2 lab"
  vpc_id      = module.network.vpc_id

  tags = {
    Name      = "terraform-web-sg"
    ManagedBy = "Terraform"
    Project   = "AWS-VPC-Lab"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  description = "Allow HTTP traffic"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow all outbound traffic"
}

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "web" {
  ami                  = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_monitoring.name

  subnet_id = module.network.public_subnet_ids["public-1"]

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  associate_public_ip_address = true
  user_data_replace_on_change = true

  depends_on = [
    aws_iam_role_policy.cloudwatch_metrics,
    aws_iam_role_policy_attachment.ssm
  ]

  user_data = templatefile("${path.module}/templates/ec2-user-data.sh.tftpl", {
    aws_region = data.aws_region.current.region
  })

  tags = {
    Name      = "terraform-web-server"
    ManagedBy = "Terraform"
    Project   = "AWS-VPC-Lab"
  }
}

