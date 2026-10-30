data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_monitoring" {
  name               = "terraform-ec2-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    ManagedBy = "Terraform"
    Project   = "AWS-EC2-Lab"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_monitoring" {
  name = "terraform-ec2-monitoring-profile"
  role = aws_iam_role.ec2_monitoring.name
}

resource "aws_iam_role_policy" "cloudwatch_metrics" {
  name = "terraform-ec2-publish-health"
  role = aws_iam_role.ec2_monitoring.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "cloudwatch:PutMetricData"
        ]

        Resource = "*"

        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "Terraform/EC2Lab"
          }
        }
      }
    ]
  })
}
