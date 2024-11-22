# AWS Resource Inventory Automation Script

## **Project Overview**

This project provides a **bash script** to automate the process of listing specific AWS resources in an account. This lightweight script focuses on querying only selected AWS services to simplify resource inventory generation.

### **Supported AWS Services**
- **EC2**: Lists EC2 instances (Regional)
- **S3**: Lists S3 buckets (Global)
- **VPC**: Lists VPCs (Regional)
- **IGW (Internet Gateways)**: Lists Internet Gateways (Regional)
- **DynamoDB**: Lists DynamoDB tables (Regional)
- **EBS**: Lists EBS volumes (Regional)

## **Key Features**
- **Simple Usage**: Just provide the AWS region and service name, and the script handles the rest.
- **Global and Regional Handling**: Automatically skips region flags for global services like S3.
- **Built-in Error Handling**: Includes checks for:
  - Valid AWS region format.
  - Proper AWS CLI installation and configuration.
  - Supported service validation.

---

## **Prerequisites**
1. **AWS CLI**: Install the AWS CLI by following [this guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
2. **AWS Credentials**: Configure the AWS CLI with valid credentials (`aws configure`).
3. **Bash Shell**: Ensure the system supports Bash (Linux, macOS, or WSL on Windows).

---

## **Usage**
Run the script with the following command:

```bash
./aws_resource_list.sh <aws_region> <aws_service>
