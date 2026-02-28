# 1. Lambda Function
resource "aws_lambda_function" "greeter" {
  filename      = "lambda_payload.zip"
  function_name = "unleash-greeter-${var.region_name}"
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"
}

# 2. IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "unleash_role_${var.region_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" } }]
  })
}

# 3. API Gateway
resource "aws_apigatewayv2_api" "api" {
  name          = "unleash-api-${var.region_name}"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "stage" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "lambda_int" {
  api_id           = aws_apigatewayv2_api.api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.greeter.invoke_arn
}

resource "aws_apigatewayv2_route" "route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "GET /secure-greet"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_int.id}"
}
# إعطاء إذن للـ API Gateway لتشغيل الـ Lambda
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.greeter.function_name
  principal     = "apigateway.amazonaws.com"

  # السطر ده بيربط الإذن بالـ API بتاعنا بالظبط
  source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
}
resource "aws_iam_role_policy" "lambda_sns_policy" {
  name = "lambda_sns_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sns:Publish"
        Effect   = "Allow"
        Resource = "arn:aws:sns:us-east-1:637226132752:Candidate-Verification-Topic"
      }
    ]
  })
}