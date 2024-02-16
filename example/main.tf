provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      safe_delete = "true"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "api-gateway-with-lambda" {
  source = "../"

  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  # --------- Only if you want to create a new VPC ---------
  # vpc_cidr_block             = "10.0.0.0/16"
  # public_subnet_cidr_blocks  = ["10.0.1.0/24", "10.0.2.0/24"]
  # private_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]
  # security_group_name        = "example-security-group"

  default_tags = {
    "Project" = "terraform-aws-lambda-apigateway"
  }

  resource_prefix = "prefix"
  apigateway = {
    name       = "example_integration"
    stage_name = "test"
  }

  lambda = {
    name       = "trem"
    version    = "0.0.0"
    runtime    = "nodejs16.x"
    handler    = "lambda.handler"
    filename   = "lambda.js"
    output_dir = "./dist"

    # --------- Use if you already have the tables created ---------
    # --------- Or if your lambda does not use DynamoDB ---------
    # dynamodb_tables = ["table1", "table2"]

    network = {
      security_groups_tag = {
        key    = "ExampleKey"
        values = ["Value1", "Value2"]
      }
      subnets_tag = {
        key    = "ExampleKey"
        values = ["Value1", "Value2"]
      }
    }
  }

  # --------- Create new DynamoDB tables ---------
  dynamodb_tables = [
    {
      name = "table1"
      hash_key = {
        name = "id"
        type = "S"
      }
    },
    {
      name = "table2"
      hash_key = {
        name = "id"
        type = "S"
      }
    }
    # ...
  ]
}
