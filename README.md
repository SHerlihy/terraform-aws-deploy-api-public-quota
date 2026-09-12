# Deploy Public API with Quota

Deploy a public API with usage limited by a public API key with specified quota.

Please see sister module responsible for drafting the API before deployment:
https://registry.terraform.io/modules/SHerlihy/draft-cors-api/aws/latest

## Example Usage

For comprehensive usage cases see:
https://github.com/SHerlihy/test_module_quota_api

### Multiple Deployments

```
module "deploy_apis" {
  providers = {
    aws = aws.product_role
  }

  for_each = local.api_names
  source   = "../deploy_api"

  api_id     = local.deploy_config_apis[each.value].api_id
  stage_name = local.deploy_config_apis[each.value].stage_name
  quota      = local.deploy_config_apis[each.value].quota
  throttle   = local.deploy_config_apis[each.value].throttle

  path_to_settings = local.deploy_config_apis[each.value].path_to_settings

  tags = local.tags
}
```
