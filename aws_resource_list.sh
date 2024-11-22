#!/bin/bash

###############################################################################
# Author: Panchanan Panigrahi
# Version: v0.1.0
#
# Script to automate the process of listing specific AWS resources in an account.
#
# Supported AWS services in this script:
# 1. EC2 (Regional)
# 2. S3 (Global)
# 3. VPC (Regional)
# 4. IGW - Internet Gateways (Regional)
# 5. DynamoDB (Regional)
# 6. EBS (Regional)
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
    echo "Supported services: ec2, s3, vpc, igw, dynamodb, ebs"
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
supported_services="ec2 s3 vpc igw dynamodb ebs"
if [[ ! " $supported_services " =~ " $aws_service " ]]; then
    echo "Error: Unsupported AWS service. Supported services are: $supported_services"
    exit 1
fi

# Function to determine if a service is global
is_global_service() {
    case $aws_service in
        s3)
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
    s3)
        echo "Listing S3 Buckets (Global)"
        aws s3api list-buckets
        ;;
    vpc)
        echo "Listing VPCs in region $aws_region"
        aws ec2 describe-vpcs $aws_region_flag
        ;;
    igw)
        echo "Listing Internet Gateways in region $aws_region"
        aws ec2 describe-internet-gateways $aws_region_flag
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
