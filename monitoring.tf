resource "aws_sns_topic" "ec2_alerts" {
  name = "terraform-ec2-health-alerts"

  tags = {
    Name      = "terraform-ec2-health-alerts"
    ManagedBy = "Terraform"
    Project   = "AWS-EC2-Lab"
  }
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.ec2_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "apache_health" {
  alarm_name        = "terraform-ec2-apache-unhealthy"
  alarm_description = "Apache is unavailable or EC2 has stopped reporting health checks"

  namespace   = "Terraform/EC2Lab"
  metric_name = "ApacheHealthy"

  statistic = "Minimum"
  period    = 60

  comparison_operator = "LessThanThreshold"
  threshold           = 1

  evaluation_periods  = 2
  datapoints_to_alarm = 2

  treat_missing_data = "breaching"

  dimensions = {
    InstanceId = aws_instance.web.id
  }

  alarm_actions = [
    aws_sns_topic.ec2_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.ec2_alerts.arn
  ]

  tags = {
    Name      = "terraform-ec2-apache-health"
    ManagedBy = "Terraform"
    Project   = "AWS-EC2-Lab"
  }
}
