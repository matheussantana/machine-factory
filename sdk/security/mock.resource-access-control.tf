############################
# User/Service Credentials #
# Module: CreateAcessProfile
############################

module "CreateAcessProfile_AdminProfile" {
  source = "../modules/security/ext/auth/CreateAccessProfile"
  username =  "admin-cloud-vm"
  namespace = var.namespace
  target_service = "ec2.amazonaws.com"
  access_level = "Allow"
  role_name = "admin-role-cloud-vm"
}

output "AuthProfile_AdminProfile" {
  value = module.CreateAcessProfile_AdminProfile
}


module "CreateAcessProfile_UserProfile" {
  source = "../modules/security/ext/auth/CreateAccessProfile"
  username = "user-cloud-vm" #var.param_auth_username #"admin-user-app-mock"
  namespace = var.namespace
  target_service = "ec2.amazonaws.com"
  access_level = "Allow"
  role_name = "user-role-cloud-vm" #var.param_auth_rolename #"admin-role-app-mock"
}

output "AuthProfile_UserProfile" {
  value = module.CreateAcessProfile_UserProfile
}

###
# Policy VM - EC2
# Module: GrantAccessTo_ACL
###

module "VM_EC2_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "vm"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "ec2"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["middleware-queue-mock-${random_integer.value.id}", "middleware-dlq-mock-${random_integer.value.id}"]
  #target_resource_id_list = ["middleware-queue-mock", "middleware-dlq-mock"]
  target_resource_id_list = ["*"]#var.param_vm_target_list

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "VM_EC2_GrantAccessTo_ACL_Adm" {
  value = module.VM_EC2_GrantAccessTo_ACL_Adm.policy
}



###
# Policy VM - EC2
# Module: GrantAccessTo_ACL
###

module "VM_EC2_GrantAccessTo_ACL_User" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "vm"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "ec2"
  operation_list = ["StartInstances", "StopInstances", "DescribeInstances", "DescribeImages", "DescribeTags", "DescribeSnapshots", "Describe*"]
  prefix = "instance/"

  #target_resource_id_list = ["middleware-queue-mock-${random_integer.value.id}", "middleware-dlq-mock-${random_integer.value.id}"]
  #target_resource_id_list = ["middleware-queue-mock", "middleware-dlq-mock"]
  target_resource_id_list = ["*"]#var.param_vm_target_list

  region = "us-east-1"
  account-id = var.account-id

  target_user_name = module.CreateAcessProfile_UserProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_UserProfile.aws-role.access_role.name
}

output "VM_EC2_GrantAccessTo_ACL_User" {
  value = module.VM_EC2_GrantAccessTo_ACL_User.policy
}


###
# Policy VM - EC2
# Module: GrantAccessTo_ACL
###

module "LOG_CloudWatch_GrantAccessTo_ACL_User" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "cloudwatch"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "cloudwatch"
  operation_list = ["Describe*", "Get*"]
  prefix = ""

  #target_resource_id_list = ["middleware-queue-mock-${random_integer.value.id}", "middleware-dlq-mock-${random_integer.value.id}"]
  #target_resource_id_list = ["middleware-queue-mock", "middleware-dlq-mock"]
  target_resource_id_list = ["*"]#var.param_vm_target_list

  region = "us-east-1"
  account-id = var.account-id

  target_user_name = module.CreateAcessProfile_UserProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_UserProfile.aws-role.access_role.name
}

output "LOG_CloudWatch_GrantAccessTo_ACL_User" {
  value = module.LOG_CloudWatch_GrantAccessTo_ACL_User.policy
}


###
# Policy S3 - Fileserver S3
# Module: GrantAccessTo_ACL
###

module "S3FS_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "s3_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "s3"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "S3FS_AcessControl_PolicyRule_Adm" {
  value = module.S3FS_GrantAccessTo_ACL_Adm.policy
}


###
# Policy DNS - Route 53
# Module: GrantAccessTo_ACL
###

module "DNS_Route53_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "dns"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "route53"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["middleware-queue-mock-${random_integer.value.id}", "middleware-dlq-mock-${random_integer.value.id}"]
  #target_resource_id_list = ["middleware-queue-mock", "middleware-dlq-mock"]
  target_resource_id_list = var.param_dns_target_list

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "DNS_Route53_GrantAccessTo_ACL_Adm" {
  value = module.DNS_Route53_GrantAccessTo_ACL_Adm.policy
}


###
# Policy ALB - Balancer
# Module: GrantAccessTo_ACL
###

module "ALBBalancer_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "lb_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "elasticloadbalancing"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "ALBBalancer_AcessControl_PolicyRule_Adm" {
  value = module.ALBBalancer_GrantAccessTo_ACL_Adm.policy
}

###
# Policy AutoScaling
# Module: GrantAccessTo_ACL
###

module "ASG_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "asg_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "autoscaling"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "ASG_AcessControl_PolicyRule_Adm" {
  value = module.ASG_GrantAccessTo_ACL_Adm.policy
}

###
# Policy Alarm
# Module: GrantAccessTo_ACL
###

module "ALARM_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "asg_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "cloudwatch"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "ALARM_AcessControl_PolicyRule_Adm" {
  value = module.ALARM_GrantAccessTo_ACL_Adm.policy
}

###
# Policy Auth
# Module: GrantAccessTo_ACL
###

module "IAM_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "asg_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "iam"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "IAM_AcessControl_PolicyRule_Adm" {
  value = module.IAM_GrantAccessTo_ACL_Adm.policy
}

###
# Policy ACM
# Module: GrantAccessTo_ACL
###

module "ACM_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "acm_acl"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "acm"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]
  #target_resource_id_list = var.param_s3fs_target_list
  target_resource_id_list = ["*"]#["ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage","ebebe150-2617-45f2-8a0a-6c7ad412c17e-app-backend-storage/*"]
  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "ACM_AcessControl_PolicyRule_Adm" {
  value = module.ACM_GrantAccessTo_ACL_Adm.policy
}


###
# Policy DB - RDS
# Module: GrantAccessTo_ACL
###

module "DB_RDS_GrantAccessTo_ACL_Adm" {
  source = "../modules/security/ext/auth/GrantAccessTo_ACL"
  policy_name = "db"
  namespace = var.namespace
  access_level = "Allow"
  target_service = "rds"
  operation_list = ["*"]
  prefix = ""

  #target_resource_id_list = ["middleware-queue-mock-${random_integer.value.id}", "middleware-dlq-mock-${random_integer.value.id}"]
  #target_resource_id_list = ["middleware-queue-mock", "middleware-dlq-mock"]
  target_resource_id_list = ["*"]#var.param_vm_target_list

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "DV_RDS_GrantAccessTo_ACL_Adm" {
  value = module.DB_RDS_GrantAccessTo_ACL_Adm.policy
}
