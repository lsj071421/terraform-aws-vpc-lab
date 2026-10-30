# AWS Terraform VPC Lab

Terraform project used to build and manage an AWS networking environment, deploy an EC2 web server, and monitor application availability using CloudWatch and SNS.

The project started as a basic VPC lab and expanded to include infrastructure automation, IAM permissions, application monitoring, and troubleshooting.

## Architecture

### Networking

* VPC: `10.20.0.0/16`
* Two public subnets:

  * `10.20.1.0/24`
  * `10.20.2.0/24`
* Private subnet: `10.20.11.0/24`
* Internet Gateway
* Public and private route tables
* Route table associations
* Security group allowing HTTP traffic

Networking resources are organized into a reusable Terraform module.

### EC2 Web Server

* Amazon Linux 2023
* Apache HTTP Server
* EC2 instance deployed in a public subnet
* IAM instance profile
* AWS Systems Manager Session Manager access
* Automated configuration through EC2 user data

The EC2 instance is configured automatically during deployment using a Terraform template.

### Monitoring and Alerting

The monitoring configuration checks Apache availability every minute and publishes the results to Amazon CloudWatch.

**Monitoring workflow:**

```text
EC2 Instance
    |
    v
Apache HTTP Server
    |
    v
Bash Health Check
    |
    v
systemd Timer
    |
    v
CloudWatch Custom Metric
    |
    v
CloudWatch Alarm
    |
    v
SNS Email Notification
```

The health-check script publishes a custom metric:

* Namespace: `Terraform/EC2Lab`
* Metric: `ApacheHealthy`
* Value `1`: Apache is responding successfully
* Value `0`: Apache is unavailable

The CloudWatch alarm evaluates the metric and sends SNS notifications when the application becomes unhealthy or recovers.

Missing metric data is also treated as a failure.

## Infrastructure Automation

Terraform manages the AWS infrastructure, including networking, EC2, IAM, CloudWatch alarms, and SNS resources.

The EC2 user-data template automatically:

1. Installs Apache.
2. Creates the website.
3. Installs the Bash health-check script.
4. Configures a systemd service.
5. Enables a systemd timer to run health checks.
6. Publishes application health metrics to CloudWatch.

This allows the EC2 environment to be recreated without manually configuring the server.

## Terraform Concepts Practiced

* Providers and variables
* Terraform modules
* Resource dependencies
* Terraform outputs
* Remote state using Amazon S3
* S3 state versioning and locking
* Infrastructure drift
* In-place updates
* Resource replacement
* Terraform templates and user data
* IAM roles and instance profiles
* Plan and apply workflows
* Infrastructure teardown and rebuild
* Git branching and pull requests

## AWS Security

Security configurations include:

* IAM roles for EC2 instead of storing AWS access keys on the instance.
* IAM permissions scoped to the CloudWatch monitoring namespace.
* Systems Manager Session Manager for remote administration without opening SSH access.
* Security group rules permitting HTTP traffic.
* S3 backend with encryption, versioning, and public access blocking.

## Troubleshooting and Incident Testing

Simulated an application outage by stopping Apache while the EC2 instance remained operational.

The monitoring system successfully:

1. Detected that Apache was unavailable.
2. Published `ApacheHealthy=0` to CloudWatch.
3. Changed the CloudWatch alarm state to `ALARM`.
4. Sent an SNS email notification.
5. Detected recovery after Apache was restarted.
6. Returned the alarm to `OK`.
7. Sent a recovery notification.

The tests demonstrated that an EC2 instance can pass its infrastructure status checks while the application running on it is unavailable.

The incident simulation was completed successfully with both manually configured monitoring and automated EC2 deployment.

## Deployment

Initialize Terraform:

```bash
terraform init
```

Validate the configuration:

```bash
terraform validate
```

Review planned changes:

```bash
terraform plan
```

Deploy the infrastructure:

```bash
terraform apply
```

Retrieve the deployed website URL:

```bash
terraform output -raw web_url
```

Verify the web server:

```bash
curl -I $(terraform output -raw web_url)
```

SNS email subscriptions must be confirmed before notifications can be delivered.

## Cost Management

The project is designed to minimize AWS costs.

* No NAT Gateway is deployed.
* EC2 uses a small instance type.
* Monitoring uses a lightweight Bash script and CloudWatch custom metric.
* Billable lab resources are destroyed when testing is complete.
* The VPC networking infrastructure and S3 Terraform backend are retained for future lab work.

EC2, EBS, public IPv4 addresses, CloudWatch metrics, alarms, and other AWS resources may incur charges.

## Project Status

The EC2 deployment and monitoring configuration have been successfully tested.

The application outage and recovery simulation passed, including CloudWatch alarm transitions and SNS notifications.

The EC2 and monitoring resources have been removed through Terraform teardown to minimize ongoing costs.

The Terraform configuration remains available for future deployments.
