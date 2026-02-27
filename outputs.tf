output "cognito_client_id" {
  value = aws_cognito_user_pool_client.client.id
}

output "api_url_east" {
  value = module.compute_east.api_endpoint
}

output "api_url_london" {
  value = module.compute_london.api_endpoint
}