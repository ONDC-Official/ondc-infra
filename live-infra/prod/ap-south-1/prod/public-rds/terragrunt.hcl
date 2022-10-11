include {
  path = find_in_parent_folders()
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))


  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/commonlib.hcl"
}

terraform {
  source = "git@github.com:cloudposse/terraform-aws-rds.git?ref=tags/0.38.8"
}


dependency "default_network" {
  config_path = "../network"
}


inputs = {
  region              = local.region_vars.locals.aws_region
  availability_zones  = ["ap-south-1a"]
  namespace           = local.environment_vars.locals.namespace
  stage               = local.environment_vars.locals.stage
  vpc_id              = dependency.default_network.outputs.default_vpc
  subnets             = [dependency.default_network.outputs.default_subnet]
  engine              = "postgres"
  database_user       = "debezium"
  database_password   = get_env("DB_PASSWORD")
  database_name       = "debezium"
  deletion_protection = false
  security_groups     = [
    dependency.default_network.outputs.aws_default_security_group
  ]
  storage_encrypted   = true
  engine_version      = "11.16"
  apply_immediately   = true
  database_port       = 5432
  publicly_accessible = true
  instance_class      = "db.t2.large"
  multi_az            = false
  db_parameter_group  = "postgres11"
  allocated_storage   = 100
  storage_type = "gp2"
  db_parameter        = [
    {
      name         = "rds.logical_replication"
      value        = "1"
      apply_method = "pending-reboot"

    }
  ]

}