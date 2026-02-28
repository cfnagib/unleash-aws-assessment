# Multi-Region Serverless Infrastructure – Unleash Live Assessment

This project demonstrates a highly available, secure, multi-region **serverless** architecture on AWS using:

- **Terraform** (IaC)  
- **AWS Lambda** (Node.js runtime)  
- **Amazon API Gateway** (HTTP API + JWT authorizer)  
- **Amazon Cognito** (user authentication & identity)  
- **Amazon DynamoDB** (multi-region, on-demand capacity)

## 🏗️ Architecture Overview

- **Identity Provider**: Amazon Cognito User Pool (deployed in primary region: `us-east-1`)  
- **Compute**: AWS Lambda functions (Node.js) deployed in two regions:  
  - `us-east-1` (N. Virginia)  
  - `eu-west-1` (Ireland)  
- **API Layer**: Amazon API Gateway with **JWT Authorizer** integrated with Cognito  
- **Storage**: DynamoDB tables created in both regions (on-demand scaling)  
- **CI/CD**: GitHub Actions workflow for Terraform validation, linting, plan & apply

## 🌍 Multi-Region Strategy

- Uses **Terraform provider aliases** to manage multiple regions cleanly  
- Primary provider → `us-east-1` (hosts Cognito User Pool – global resource)  
- Secondary provider → `eu-west-1`  
- The `compute` module is invoked twice — once per region — passing the appropriate provider and region variables  

This approach ensures identical Lambda + DynamoDB resources in both regions while keeping them independent.

## 🚀 Deployment Instructions

```bash
# 1. Initialize Terraform (downloads providers & modules)
terraform init

# 2. Preview the planned changes
terraform plan

# 3. Apply the infrastructure
# (remove -auto-approve if you prefer manual confirmation)
terraform apply -auto-approve
🧪 Testing the Deployment

Install Python dependencies:

Bashpip install boto3 requests

Run the test script:

Bashpython3 test_assessment.py
What the script does:

Authenticates against Cognito (sign-up / sign-in)
Obtains a JWT ID token
Calls the API Gateway endpoint
Triggers the verification flow (SNS payload)

🧹 Cleanup
To avoid unnecessary charges, destroy all resources:
Bashterraform destroy -auto-approve
📋 Additional Notes
Prerequisites

AWS CLI configured with sufficient permissions
Terraform ≥ 1.5.x
Python 3.8+

Security Considerations

Never commit AWS credentials or secrets
Prefer AWS SSO / OIDC / IAM roles for CI/CD

Possible Future Improvements

Add Amazon Route 53 latency-based routing
Attach AWS WAF to API Gateway
Enable detailed CloudWatch monitoring + alarms
Add cross-region replication / failover testing