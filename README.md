

# AWS Resource Inventory Automation Script

## **Project Overview**

This project provides a **bash script** that automates the process of listing resources in an AWS account for various services such as EC2, RDS, S3, CloudFront, VPC, IAM, Route53, CloudWatch, CloudFormation, Lambda, SNS, SQS, DynamoDB, and EBS. The script intelligently handles both **regional** and **global AWS services**, ensuring that the right resources are queried without region-based constraints.

## **Key Features**
- **Supports Multiple AWS Services**: EC2, RDS, S3, CloudFront, VPC, IAM, Route53, CloudWatch, CloudFormation, Lambda, SNS, SQS, DynamoDB, and EBS.
- **Automatic Handling of Global Services**: Services like S3, IAM, and Route53 that are global are detected, and region flags are skipped for them.
- **Simple Usage**: Users provide just the AWS region and service name, and the script handles the rest.
- **Built-in Error Handling**: The script includes checks for AWS CLI installation, configuration, region format validation, and service validation.
  
## **Prerequisites**
1. **AWS CLI**: You must have the AWS CLI installed. You can follow [this guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) to install the AWS CLI.
2. **AWS Credentials**: The AWS CLI must be configured with valid credentials (using `aws configure`).
3. **Bash Shell**: This script runs on systems with Bash available (Linux, macOS, WSL on Windows).

## **Installation**
1. Clone this repository or download the script directly:
   ```bash
   git clone <repository-url>
   ```
2. Ensure the script is executable:
   ```bash
   chmod +x aws_resource_list.sh
   ```

## **Usage**
```bash
./aws_resource_list.sh <aws_region> <aws_service>
```
Example:
```bash
./aws_resource_list.sh us-east-1 ec2
```

### **Supported AWS Services**
- **EC2**: Lists EC2 instances (Regional)
- **RDS**: Lists RDS instances (Regional)
- **S3**: Lists S3 buckets (Global)
- **CloudFront**: Lists CloudFront distributions (Global)
- **VPC**: Lists VPCs (Regional)
- **IAM**: Lists IAM users (Global)
- **Route53**: Lists Route53 hosted zones (Global)
- **CloudWatch**: Lists CloudWatch alarms (Regional)
- **CloudFormation**: Lists CloudFormation stacks (Regional)
- **Lambda**: Lists Lambda functions (Regional)
- **SNS**: Lists SNS topics (Regional)
- **SQS**: Lists SQS queues (Regional)
- **DynamoDB**: Lists DynamoDB tables (Regional)
- **EBS**: Lists EBS volumes (Regional)

## **Error Handling**
- If an invalid service is provided, the script will notify the user and provide a list of supported services.
- For global services, the script automatically skips the AWS region flag, ensuring smooth resource listing.
- The script validates that the AWS CLI is installed and configured properly before proceeding with any AWS API calls.

