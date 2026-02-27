# 1. إنشاء مجمع مستخدمين (Cognito User Pool)
resource "aws_cognito_user_pool" "pool" {
  name = "${var.project_name}-user-pool"

  password_policy {
    minimum_length = 8
  }
}

# 2. إنشاء عميل للمجمع (User Pool Client) - سنحتاجه للـ Login
resource "aws_cognito_user_pool_client" "client" {
  name         = "${var.project_name}-client"
  user_pool_id = aws_cognito_user_pool.pool.id
  
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

# 3. إنشاء مستخدم اختبار (Test User) باستخدام إيميلك
resource "aws_cognito_user" "test_user" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username     = var.candidate_email
  password     = "UnleashPass123!" # كلمة مرور مؤقتة (يجب أن تحتوي على حروف وأرقام)

  attributes = {
    email          = var.candidate_email
    email_verified = true
  }
}

# تعريف الموديول لمنطقة أمريكا (East)
module "compute_east" {
  source              = "./modules/compute"
  region_name         = "us-east-1"
  user_pool_client_id = aws_cognito_user_pool_client.client.id
  user_pool_endpoint  = aws_cognito_user_pool.pool.endpoint
}

# تعريف الموديول لمنطقة لندن (London)
module "compute_london" {
  source              = "./modules/compute"
  providers = {
    aws = aws.london
  }
  region_name         = "eu-west-1"
  user_pool_client_id = aws_cognito_user_pool_client.client.id
  user_pool_endpoint  = aws_cognito_user_pool.pool.endpoint
}