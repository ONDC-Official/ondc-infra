include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  common_vars = read_terragrunt_config("${dirname(find_in_parent_folders())}/_envcommon/commonlib.hcl")

  common_scripts_path = "${dirname(find_in_parent_folders())}/scripts"

}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/commonlib.hcl"
}

terraform {
  source = "${local.common_vars.locals.base_cloudposse_source_url}/terraform-aws-ec2-instance.git?ref=tags/0.42.0"
}


dependency "network" {
  config_path = "../network"
}

dependency "key-pair" {
  config_path = "../bridge_instance_key_pair"
}

inputs = {
  namespace                   = local.environment_vars.locals.namespace
  stage                       = local.environment_vars.locals.stage
  name                        = "${ local.environment_vars.locals.name }-analytics-logging-api"
  vpc_id                      = dependency.network.outputs.default_vpc
  ssh_key_pair                = dependency.key-pair.outputs.key_name
  subnet                      = dependency.network.outputs.default_subnet
  associate_public_ip_address = true
  ebs_volume_count            = 1
  instance_type               = "t3.large"
  assign_eip_address          = false
  region                      = local.region_vars.locals.aws_region
  root_volume_size            = 100
  security_groups             = [
    dependency.network.outputs.aws_default_security_group
  ]
  security_group_rules = [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },

  ]
  user_data = file("${local.common_scripts_path}/docker-compose-install.sh")
}