resource "aws_dynamodb_table" "this" {
  for_each = tomap(var.dynamodb_tables != null ? { for table in var.dynamodb_tables : table.name => table } : {})

  name           = each.key
  billing_mode   = each.value.billing_mode
  read_capacity  = each.value.read_capacity
  write_capacity = each.value.write_capacity
  hash_key       = each.value.hash_key.name
  range_key      = each.value.range_key != null ? each.value.range_key.name : null

  attribute {
    name = each.value.hash_key.name
    type = each.value.hash_key.type
  }

  dynamic "attribute" {
    for_each = tomap(each.value.range_key != null ? { for range_key in [each.value.range_key] : range_key.name => range_key } : {})
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = var.default_tags
  lifecycle {
    ignore_changes = [tags]
  }
}
