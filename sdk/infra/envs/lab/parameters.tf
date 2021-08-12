variable "my_optional_variable" {
  default = ""
}

# Network
variable param_network_id { default = "vpc-038aaa79" }

# Balancer Network & Subnet
#variable param_balancer_subnet-group_name { default = "balancer-subnet-group" }
variable param_balancer_subnet_ids_list {
  type = list
  default = ["subnet-032ab85a", "subnet-05725c3f"]

}
