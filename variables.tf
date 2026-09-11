locals {
  quota_periods = ["DAY","WEEK","MONTH"]
}

variable "api_id" {
  description = "Id of REST API to deploy."
  type = string
  validation {
    condition     = length(regexall("^[a-z0-9]{10}$", var.api_id)) > 0
    error_message = "The api_id must be exactly 10 lowercase alphanumeric characters."
  }
}

variable "stage_name" {
  description = "Stage name of deployed API that you set."
  type = string
}

variable "quota" {
  description = "Quota limit to apply to the deployed API."
  type = object({
      limit = number
      period = string
  })

  validation {
    condition = contains(local.quota_periods, var.quota.period)
    error_message = "quota.period must be one of ${local.quota_periods}"
  }
}

variable "throttle" {
  description = "Throttling to apply to the deployed API."
    type = object({
      burst: number
      rate: number
    })
}

variable "path_to_settings" {
  description = "Throttling to apply to deployed API paths."
    type = map(object({
      burst_limit = number
      rate_limit = number
  }))
}

locals {
  path_burst_total = sum([ for key, value in var.path_to_settings : value.burst_limit])
  path_rate_total = sum([ for key, value in var.path_to_settings : value.rate_limit])
}

check "path_settings_v_api_settings" {
  assert {
    condition = var.throttle.burst >= local.path_burst_total
    error_message = "Sum of path burst limits greater than API burst limit by ${local.path_burst_total-var.throttle.burst}"
  }
  assert {
    condition = var.throttle.rate >= local.path_rate_total
    error_message = "Sum of path rate limits greater than API rate limit by ${local.path_rate_total-var.throttle.rate}"
  }
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
}

locals {
  paths = toset([for key, value in var.path_to_settings : key])
}
