variable group_name {}
variable family_name {}
variable namespace {}

resource "aws_db_parameter_group" "default" {
  name = "${var.namespace}-${var.group_name}"
  family = var.family_name

}

output "db_parameter_group" {
  value = aws_db_parameter_group.default
}