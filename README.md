Multi-Region Serverless Infrastructure (Unleash Live Assessment)
This project demonstrates a highly available, secure, and multi-region AWS infrastructure using Terraform, AWS Lambda, API Gateway, and Amazon Cognito.

🏗️ Architecture Overview
The infrastructure is deployed across two AWS regions to ensure global availability and low latency.

Identity Provider: Amazon Cognito User Pool (Primary Region: us-east-1).

Compute: AWS Lambda (Node.js) deployed in us-east-1 (N. Virginia) and eu-west-1 (London).

API Layer: Amazon API Gateway (HTTP API) with JWT Authorization linked to Cognito.

Database: DynamoDB tables created in both regions (On-demand scaling).

CI/CD: GitHub Actions workflow for automated Terraform Plan/Linting.

🌐 Multi-Region Strategy
To manage multiple regions cleanly, I used Terraform Provider Aliases.

A primary provider is defined for us-east-1 (hosting the Cognito User Pool).

A secondary provider is defined for eu-west-1.

The compute module is called twice, passing the specific provider and region to each instance. This ensures that the Lambda and DynamoDB resources are identical in both locations but operate independently.

🚀 How to Deploy
Initialize Terraform:

Bash
terraform init
Plan & Apply:

Bash
terraform plan
terraform apply -auto-approve
🧪 Testing the Deployment
Install dependencies: pip install boto3 requests

Run the script: python3 test_assessment.py
(The script authenticates with Cognito, retrieves a JWT, and triggers the SNS verification payload).

🧹 Cleanup
To avoid charges, run:

Bash
terraform destroy -auto-approve