# terraform-aws-deploy-api-public-quota

Deploy a public API with usage limited by a public API key with specified quota.

Please see sister module responsible for drafting the API before deployment:
https://registry.terraform.io/modules/SHerlihy/draft-cors-api/aws/latest

## Prerequisites
- An active AWS Account configured with appropriate IAM permissions.
- Terraform `~> 1.0`

## Examples

For comprehensive usage cases see:
https://github.com/SHerlihy/test_module_quota_api

```hcl
locals {
  path_to_settings : {
    var.path_A_id : {
      burst_limit : var.path_A_burst
      rate_limit : var.path_A_limit
    },
    var.path_B_id : {
      burst_limit : var.path_B_burst
      rate_limit : var.path_B_limit
    }
  }
}

module "deploy_api" {
  source  = "SHerlihy/deploy-api-public-quota/aws"
  version = "0.0.1"

  api_id     = aws_api_gateway_rest_api.default.id
  stage_name = var.stage_name
  quota      = var.quota
  throttle   = var.throttle

  path_to_settings = local.path_to_settings

  tags = var.tags
}
```
