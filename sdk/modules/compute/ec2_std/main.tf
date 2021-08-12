
variable vm_key {
  default = "default_key"
  type = string
}

variable "namespace" {
  type = string
}

variable "stage" {
  type = string
  default = "dev"
}

variable "region" {
  type = string
}



variable "ami_owner" {
  type = string
  default = "672200747926"
}

variable "function_name" {
  type = string
  default = "default_backup_name"
}

variable user_data {
  type = string
}

variable name {
  type = string
  default = "default_ec2"
}

variable id {
  type = string
  default = "00000000-0000-0000-0000-000000000000"
}

variable instance_profile {
  type = string
  default = "None"
}

variable firewall_id {
  type = list(string)
  default = ["None"]
}

variable subnet_id {
        type = string
        default = "subnet-45aeba22"
}

variable quant_inst {
        type = string
        default = 1
}

variable os_image {
        type = string
        default = "ami-0e6d2e8684d4ccb3e"
}
variable model {
        type = string
        default = "t2.medium"
}

variable disk_size {
        type = string
        default = "10"
}

#variable environment {}

module "ec2-vm" {
  source                 = "../vm-cluster-ec2"
  #version                = "~> 2.0"

  name                   = "${var.name}"
  instance_count         = var.quant_inst

  associate_public_ip_address = "true"

  ami                    = var.os_image
  instance_type          = var.model
  key_name               = "${var.vm_key}"
  monitoring             = true
  vpc_security_group_ids = var.firewall_id
  subnet_id              = var.subnet_id
  user_data = var.user_data
  iam_instance_profile = var.instance_profile

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.disk_size
    },
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    id = "${var.id}"
    Class = "VM"
  }
}


output "ec2_std" {
  value = module.ec2-vm
}

output "ec2_std_vip" {
  value = module.ec2-vm.vip
}