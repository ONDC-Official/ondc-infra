include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  common_vars = read_terragrunt_config("${dirname(find_in_parent_folders())}/_envcommon/commonlib.hcl")

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/commonlib.hcl"
}

terraform {
  source = "${local.common_vars.locals.base_cloudposse_source_url}/terraform-aws-key-pair.git?ref=tags/0.18.3"
}


inputs = {
  namespace  = local.environment_vars.locals.namespace
  stage      = local.environment_vars.locals.stage
  name       = "${local.environment_vars.locals.namespace}-ec2-key-pair"
  attributes = [
    "ssh",
    "key"
  ]
  ssh_public_key_path = "/tmp"
  generate_ssh_key    = true

}