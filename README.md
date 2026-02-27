# Multi-Region Serverless Infrastructure (Unleash Live Assessment)

This project demonstrates a highly available, secure, and multi-region AWS infrastructure using **Terraform**, **AWS Lambda**, **API Gateway**, and **Amazon Cognito**.

## 🏗️ Architecture Overview
The infrastructure is deployed across two AWS regions to ensure global availability and low latency.

- **Identity Provider:** Amazon Cognito User Pool (Primary Region: `us-east-1`).
- **Compute:** AWS Lambda (Node.js) deployed in `us-east-1` (N. Virginia) and `eu-west-1` (London).
- **API Layer:** Amazon API Gateway (HTTP API) with JWT Authorization linked to Cognito.
- **Database:** DynamoDB tables created in both regions (On-demand scaling).
- **CI/CD:** GitHub Actions workflow for automated Terraform Plan/Linting.



## 📁 Project Structure
- `main.tf`: Main entry point (Cognito & Module calls).
- `variables.tf`: Global variables (Emails, Project names).
- `outputs.tf`: Final API Endpoints and Client IDs.
- `modules/compute/`: Reusable module for Lambda, API Gateway, and DynamoDB.
- `test_assessment.py`: Python script to validate Auth and API connectivity.
- `.github/workflows/deploy.yml`: CI/CD pipeline configuration.

## 🚀 How to Deploy
1. **Initialize Terraform:**
   ```bash
   terraform init