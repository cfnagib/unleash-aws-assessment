terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# المنطقة الأساسية (N. Virginia) - سيتم إنشاء Cognito هنا
provider "aws" {
  region = "us-east-1"
}

# المنطقة الثانية (London) - للتوزيع الجغرافي
provider "aws" {
  region = "eu-west-1"
  alias  = "london"
}