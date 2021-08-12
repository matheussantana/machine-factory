# Network
variable param_network_id { default = "vpc-038aaa79" }

# Cache Network & Subnet - Redis
variable param_cache_subnet-group_name { default = "cache-subnet-group" }
variable param_cache_subnet_ids_list {
  type = list
  default = ["subnet-032ab85a", "subnet-05725c3f"]

}

# Cache Firewall - Redis

variable param_cache_firewall_name { default = "firewall-cache-mock" }
variable param_cache_firewall_port { default = "6479" }
variable param_cache_ip_range_list {
  type = list
  default = [
    "10.138.224.0/20",
    "10.196.138.0/24",
    "10.196.136.0/24"
  ]
}

# Auth - User & Role

variable param_auth_rolename {default = "admin-role-app-mock"}
variable param_auth_username {default = "admin-user-app-mock"}

variable param_dyndb_target_list {
  type = list
  default = ["nosqlDB-mock"]
}
variable param_s3fs_backend_target_list {
  type = list
  default = ["default-backend-storage*", "default-backend-storage/*"]
}
variable param_s3fs_target_list {
  type = list
  default = ["s3-fileserver-mock*", "s3-fileserver-mock/*"]
}
variable param_sqs_target_list {
  type = list
  default = ["middleware-queue-mock", "middleware-dlq-mock"]
}

variable param_oracledb_target_list {
  type = list
  default = ["pgsqloracle*","sql-rds-subnet*"]
}

variable param_mysqldb_target_list {
  type = list
  default = ["mockmysql","pgsqlmysql*","sql-rds-subnet*"]
}


# SQL Network & Subnet
variable param_sql_subnet_ids_list {
  type = list
  default = ["subnet-032ab85a", "subnet-05725c3f"]
}

variable param_sql_subnet_group_name {
  default = "sql-rds-subnet"
}

# SQL Firewall - RDS
variable param_sql_firewall_name { default = "firewall-sql-mock" }
variable param_sql_firewall_port_mysql { default = "3306" }
variable param_sql_firewall_port_oracle { default = "1521" }

# SQL Parameters - Mysql
variable param_sql_mysql_param_group_name { default = "pgsqlmysql"}
variable param_sql_oracle_param_group_name { default = "pgsqloracle"}

# FS Backend
variable param_s3fs_backend_partition_name { default = "default-backend-storage"}

# Firewall/SG EC2/VM
variable param_vm_firewall_name { default = "firewall-vm-mock" }
variable param_vm_firewall_from_port_ec2 { default = "0" }
variable param_vm_firewall_from_to_ec2 { default = "65535" }

variable param_vm_ip_range_list {
  type = list
  default = [
    "0.0.0.0/0"
  ]
}

variable param_vm_target_list {
  type = list
  default = ["*"]
}


variable param_dns_target_list {
  type = list
  default = ["*"]
}
