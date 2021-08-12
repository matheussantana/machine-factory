#resource "random_uuid" "test" { }

variable id {
  type = string
  default = "ebebe150-2617-45f2-8a0a-6c7ad412c17e"
  #default =  "${random_uuid.test.result}"

}

variable instance_profile {
  type = string
  default = ""
}

variable firewall_id {
  type = list(string)
  default = ["sg-0444a67cbc15a039e"]
}

variable subnet_id {
        type = string
        default = "subnet-45aeba22"
}

variable quant_inst {
        type = string
        default = "1"
}

resource "aws_key_pair" "deploy" {
  key_name   = var.namespace
#  public_key = "${file("./files/certs/mock/id_rsa.pub")}"
  public_key = "${file("../../../sec-info/Keys/SSH/2020-11-05/id_rsa.pub")}"

}

module "ec2_vm_002" {
  source = "../modules/compute/ec2_std"
  namespace = var.namespace
  name = format("%s/%s",var.namespace,"vm_002")
  id = format("%s/%s",var.namespace,"vm_002")
  vm_key = aws_key_pair.deploy.key_name
  region = var.region
  #user_data = "${file("../../../applet/install.sh")}"
  user_data = "${file("./files/basic_user_data.sh")}"
  instance_profile = var.instance_profile
  firewall_id = var.firewall_id
  subnet_id = var.subnet_id
  quant_inst = var.quant_inst
  disk_size = "50"
  os_image = "ami-0a318d7ca9d31bd64"
}

output "ec2_vm_002" {
  value = module.ec2_vm_002
}


module "ec2_vm_005" {
  source = "../modules/compute/ec2_std"
  namespace = var.namespace
  name = format("%s/%s",var.namespace,"prd-zeta")
  id = format("%s/%s",var.namespace,"prd-zeta")
  vm_key = aws_key_pair.deploy.key_name
  region = var.region
  #user_data = "${file("../../../applet/install.sh")}"
  user_data = "${file("./files/basic_user_data.sh")}"
  instance_profile = var.instance_profile
  firewall_id = var.firewall_id
  subnet_id = var.subnet_id
  quant_inst = var.quant_inst
  disk_size = "50"
  os_image = "ami-02f67d42ab9041b45"
  model = "t2.small"
}

output "ec2_vm_005" {
  value = module.ec2_vm_005
}


/*
##
resource "aws_key_pair" "deploy-test" {
  key_name   = "test-pem"
  public_key = "${file("../../../sec-info/Keys/SSH/2020-11-05/id_rsa.pub")}"

}

module "ec2_vm_006" {
  source = "../modules/compute/ec2_std"
  namespace = var.namespace
  name = format("%s/%s",var.namespace,"6")
  id = format("%s/%s",var.namespace,"6")
  vm_key = aws_key_pair.deploy-test.key_name
  region = var.region
  user_data = "${file("../../../applet/install.sh")}"
  instance_profile = var.instance_profile
  firewall_id = var.firewall_id
  subnet_id = var.subnet_id
  quant_inst = var.quant_inst
  disk_size = "50"
  os_image = "ami-0ff8a91507f77f867"
  model = "t2.small"
}

output "ec2_vm_006" {
  value = module.ec2_vm_006
}
*/