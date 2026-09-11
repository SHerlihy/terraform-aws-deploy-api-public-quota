output "endpoint" {
  description = "URL for endpoint."
  value       = aws_api_gateway_stage.default.invoke_url
}

output "api_key" {
  description = "API key subject to quota."
  value       = nonsensitive(aws_api_gateway_api_key.default.value)
}
