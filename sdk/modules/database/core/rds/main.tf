variable "namespace" {
  type = string
}

variable "storage_size" {
  type = string
  default = 50
}

variable "storage_type" {
  type = string
  default = "gp2"
}

variable engine {
  type = string
}

variable engine_version {
  type = string
}

variable db_name {
  type = string
}

variable db_username {
  type = string
}

variable db_password {
  type = string
}

variable backup_window {
  type = string
  default = "00:00-01:59"
}

variable backup_retention_period {
  type = string
  default = 30
}

variable maintenance_window {
  type = string
  default = "Mon:02:00-Mon:05:00"
}

variable publicly_accessible {
  type = string
  default = "false"
}

variable multi_az {
  type = string
  default = "true"
}

variable license_model {
  #Valid values: license-included | bring-your-own-license | general-public-license
  type = string
  default = "license-included"
}

variable instance_class {
  type = string
}

variable db_port {
  type = string
}

variable final_snapshot_identifier {
  type = string
  default = "last-snapshot"
}

variable parameter_group_name {
  type = string
}

variable db_subnet_group_name {
  type = string
}

variable "tags" {
  type = map
}

variable "firewall-sg-id" {
  type = list(string)
}

variable deletion_protection {
  type = string
  default = false

}

variable skip_final_snapshot{
  type = string
  default = true
}

resource "aws_db_instance" "default" {
  identifier                  = "${var.namespace}-${var.db_name}"
  name                        = var.db_name#"${var.namespace}-${var.db_name}"
  username                    = var.db_username
  password                    = var.db_password
  port                        = var.db_port
  engine                      = "${var.engine}"
  engine_version              = "${var.engine_version}"
  instance_class              = "${var.instance_class}"
  allocated_storage           = var.storage_size
  #storage_encrypted           = "${var.storage_encrypted}"
  #kms_key_id                  = "${var.kms_key_arn}"
  vpc_security_group_ids      = var.firewall-sg-id
  db_subnet_group_name        = var.db_subnet_group_name
  parameter_group_name        = var.parameter_group_name
  #option_group_name           = "${length(var.option_group_name) > 0 ? var.option_group_name : join("", aws_db_option_group.default.*.name)}"
  license_model               = "${var.license_model}"
  multi_az                    = "${var.multi_az}"
  storage_type                = "${var.storage_type}"
  #iops                        = "${var.iops}"
  publicly_accessible         = "${var.publicly_accessible}"
  #snapshot_identifier         = "${var.snapshot_identifier}"
  allow_major_version_upgrade = "true"
  auto_minor_version_upgrade  = "true"
  apply_immediately           = "true"
  maintenance_window          = var.maintenance_window
  skip_final_snapshot         = var.skip_final_snapshot #"false"
  copy_tags_to_snapshot       = "true"
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  tags                        = var.tags
  deletion_protection         = var.deletion_protection
  final_snapshot_identifier   = "${var.final_snapshot_identifier}-${var.namespace}-${var.db_name}"
}

output "aws_db_instance" {
  value = aws_db_instance.default
}

/*
resource "aws_db_parameter_group" "default" {
  count     = "${(length(var.parameter_group_name) == 0 && var.enabled == "true") ? 1 : 0}"
  name      = "${module.label.id}"
  family    = "${var.db_parameter_group}"
  tags      = "${module.label.tags}"
  parameter = "${var.db_parameter}"
}

resource "aws_db_option_group" "default" {
  count                = "${(length(var.option_group_name) == 0 && var.enabled == "true") ? 1 : 0}"
  name                 = "${module.label.id}"
  engine_name          = "${var.engine}"
  major_engine_version = "${var.major_engine_version}"
  tags                 = "${module.label.tags}"
  option               = "${var.db_options}"

  lifecycle {
    create_before_destroy = true
  }
}*/

