# Firewall/SG for ec2

module "firewall-ec2" {
  source = "../modules/network/core/firewall-security-group"
  namespace = var.namespace
  firewall_name = var.param_vm_firewall_name
  network_id = var.param_network_id
  tags = var.tags
}


output "firewall-ec2" {
  value = module.firewall-ec2
}

module "firewall-rule-id-ec2" {
  source = "../modules/network/core/firewall-security-group-rule-ip-based"
  namespace = var.namespace
  from_port = var.param_vm_firewall_from_port_ec2
  to_port = var.param_vm_firewall_from_to_ec2
  firewall-id = module.firewall-ec2.firewall.id

  ip_range_list = var.param_vm_ip_range_list

}

output "firewall-rule-id-ec2" {
  value = module.firewall-rule-id-ec2
}