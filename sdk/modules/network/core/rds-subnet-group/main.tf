variable namespace {}
variable subnet_ids {
  type = list(string)
}
variable tags {}
variable subnet_group_name {
  type = string
  default = "default-db-subnet"
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.namespace}-${var.subnet_group_name}"
  subnet_ids = var.subnet_ids
  tags       = var.tags
}

output db-subnet-group {
  value = aws_db_subnet_group.default
}