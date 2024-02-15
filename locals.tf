locals {
  api_gateway_name    = var.resource_prefix != null ? "${var.resource_prefix}__${var.apigateway.name}" : var.apigateway.name
  apigateway_resource = toset(var.apigateway.create_api == true ? [local.api_gateway_name] : [])
  rest_api            = var.apigateway.create_api == true ? aws_api_gateway_rest_api.custom_api[local.api_gateway_name] : data.aws_api_gateway_rest_api.custom_api_data[local.api_gateway_name]
  cognito_user_pool   = toset(var.apigateway.cognito_user_pool_name != null ? [var.apigateway.cognito_user_pool_name] : [])
  function_name       = var.resource_prefix != null ? "${var.resource_prefix}__${var.lambda.name}" : var.lambda.name

  subnet_ids         = var.lambda.network.subnets_tag != null ? data.aws_subnets.functions.ids : var.vpc_cidr_block != null ? [aws_subnet.public_subnet[0].id, aws_subnet.private_subnet[0].id] : null
  security_group_ids = var.lambda.network.security_groups_tag != null ? data.aws_security_groups.functions.ids : var.security_group_name != null ? [aws_security_group.lambda[0].id] : null

  dynamodb_tables_arn = var.dynamodb_tables != null ? [for table in var.dynamodb_tables : aws_dynamodb_table.this[table.name].arn] : length(var.lambda.dynamodb_tables) > 0 ? [for table in var.lambda.dynamodb_tables : data.aws_dynamodb_table.table_name[table.name].arn] : null
}
