variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "resource_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = null
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  type        = string
  default     = null
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnets"
  type        = list(string)
  default     = []
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

variable "dynamodb_tables" {
  description = "List of DynamoDB table properties for creation"
  type = list(object({
    name = string

    hash_key = object({
      name = string
      type = string
    })
    range_key = optional(object({
      name = string
      type = string
    }))

    billing_mode   = optional(string, "PAY_PER_REQUEST")
    read_capacity  = optional(number)
    write_capacity = optional(number)
  }))
  default = []
}

variable "lambda" {
  type = object({
    name        = string
    version     = string
    description = optional(string)
    memory_size = optional(number)
    timeout     = optional(number)
    runtime     = string
    handler     = string
    filename    = optional(string)
    root_dir    = optional(string)
    output_dir  = string
    environment = optional(map(string))

    dynamodb_tables = optional(list(string), [])
    s3_buckets      = optional(list(string), [])

    network = optional(object({
      security_groups_tag = object({
        key    = string
        values = list(string)
      })
      subnets_tag = object({
        key    = string
        values = list(string)
      })
    }), null)
  })

  description = "Configuration for Lambda"
}

variable "apigateway" {
  type = object({
    name        = string
    create_api  = optional(bool, true)
    description = optional(string)
    stage_name  = string

    cognito_user_pool_name = optional(string, null)
  })

  description = "Configuration for API Gateway"
}
