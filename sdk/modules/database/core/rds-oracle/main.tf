###
# Resource RDS
# Module: rds
###

variable namespace {}
variable db_name {}
variable db_username {}
variable db_password {}
variable firewall-sg-id {}
variable tags {}
variable instance_family {
  type = string
  default = "db.m4.large"
}
variable version {
  default = "oracle-se2"
}
variable release {
  default = "12.2.0.1.ru-2019-04.rur-2019-04.r1"
}

varaible subnet_group {}

module "sql-rds" {
  source = "../rds"
  namespace = var.namespace
  db_name = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  db_subnet_group_name = var.subnet_group
  parameter_group_name = "${var.namespace}-${var.db_name}"
  engine = var.version
  engine_version = var.release
  tags = var.tags
  instance_class = var.instance_family
  license_model = "license-included"
  firewall-sg-id = ["${var.firewall-sg-id}"]
  db_port = "1521"


}

output "sql-rds" {
  value = module.sql-rds
}