#!/bin/bash

###############################################################################
# Author: Panchanan Panigrahi
# Version: v0.0.3
#
# Script to automate the process of listing all the resources in an AWS account.
#
# Supported AWS services in this script:
# 1. EC2 (Regional)
# 2. RDS (Regional)
# 3. S3 (Global)
# 4. CloudFront (Global)
# 5. VPC (Regional)
# 6. IAM (Global)
# 7. Route53 (Global)
# 8. CloudWatch (Regional)
# 9. CloudFormation (Regional)
# 10. Lambda (Regional)
# 11. SNS (Regional)
# 12. SQS (Regional)
# 13. DynamoDB (Regional)
# 14. EBS (Regional)
#
# The script prompts the user to enter the AWS region and service for which 
# the resources need to be listed. Some services (like IAM and S3) are global 
# and do not require a specific region.
#
# Usage: ./aws_resource_list.sh <aws_region> <aws_service>
# Example: ./aws_resource_list.sh us-east-1 ec2
###############################################################################

# Exit script on any error
set -e

# Function to display usage
usage() {
    echo "Usage: $0 <aws_region> <aws_service>"
    echo "Example: $0 us-east-1 ec2"
    echo "Supported services: ec2, rds, s3, cloudfront, vpc, iam, route53, cloudwatch, cloudformation, lambda, sns, sqs, dynamodb, ebs"
}

# Check if the required number of arguments are passed
if [ $# -ne 2 ]; then
    usage
    exit 1
fi

# Assign the arguments to variables and convert the service to lowercase
aws_region=$1
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# Validate AWS region format (basic validation for format like us-east-1)
if [[ ! $aws_region =~ ^[a-z]{2}-[a-z]+-[0-9]{1}$ ]]; then
    echo "Error: Invalid AWS region format. Please provide a valid region (e.g., us-east-1)."
    exit 1
fi

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
fi

# Check if the AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS CLI is not configured. Please configure the AWS CLI (credentials and region) and try again."
    exit 1
fi

# Validate AWS service input
supported_services="ec2 rds s3 cloudfront vpc iam route53 cloudwatch cloudformation lambda sns sqs dynamodb ebs"
if [[ ! " $supported_services " =~ " $aws_service " ]]; then
    echo "Error: Unsupported AWS service. Supported services are: $supported_services"
    exit 1
fi

# Function to determine if a service is global
is_global_service() {
    case $aws_service in
        iam|s3|cloudfront|route53)
            return 0  # Global services
            ;;
        *)
            return 1  # Regional services
            ;;
    esac
}

# Adjust the region flag for global services
if is_global_service; then
    echo "Listing resources for global service $aws_service"
    aws_region_flag=""
else
    aws_region_flag="--region $aws_region"
fi

# List the resources based on the service
case $aws_service in
    ec2)
        echo "Listing EC2 Instances in region $aws_region"
        aws ec2 describe-instances $aws_region_flag
        ;;
    rds)
        echo "Listing RDS Instances in region $aws_region"
        aws rds describe-db-instances $aws_region_flag
        ;;
    s3)
        echo "Listing S3 Buckets (Global)"
        aws s3api list-buckets
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions (Global)"
        aws cloudfront list-distributions
        ;;
    vpc)
        echo "Listing VPCs in region $aws_region"
        aws ec2 describe-vpcs $aws_region_flag
        ;;
    iam)
        echo "Listing IAM Users (Global)"
        aws iam list-users
        ;;
    route53)
        echo "Listing Route53 Hosted Zones (Global)"
        aws route53 list-hosted-zones
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in region $aws_region"
        aws cloudwatch describe-alarms $aws_region_flag
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in region $aws_region"
        aws cloudformation describe-stacks $aws_region_flag
        ;;
    lambda)
        echo "Listing Lambda Functions in region $aws_region"
        aws lambda list-functions $aws_region_flag
        ;;
    sns)
        echo "Listing SNS Topics in region $aws_region"
        aws sns list-topics $aws_region_flag
        ;;
    sqs)
        echo "Listing SQS Queues in region $aws_region"
        aws sqs list-queues $aws_region_flag
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in region $aws_region"
        aws dynamodb list-tables $aws_region_flag
        ;;
    ebs)
        echo "Listing EBS Volumes in region $aws_region"
        aws ec2 describe-volumes $aws_region_flag
        ;;
    *)
        echo "Error: Invalid service specified."
        usage
        exit 1
        ;;
esac
