

## Quick start

### Service: Security workspace - Privileged mode


Before we start to create the resources we first have to configure service and environment parameters.
But first let's create the **security** service workspace using the utils tool.

For container-based:
```
$ cd utils/iaas-tool/
$ ls
docker-compose.yml  srv  start-workflow.sh
```
Open the **docker-compose.yml** and uncomment the security service line:

```
....
# configure/setup service environment

command: ./tmp/init.sh cfg-srv init security
...
```

Then run the **star-workflow** tool:

```
$ ./start-workflow.sh
Building infra-workflow-manager
Step 1/7 : FROM centos:latest
 ---> 49f7960eb7e4
Step 2/7 : ADD ./conf.d/exec.sh /tmp/exec.sh
 ---> Using cache
 ---> 48bd4c0d7ff5
Step 3/7 : RUN ["chmod", "+x", "/tmp/exec.sh"]
 ---> Using cache
 ---> f637f3c12b38
Step 4/7 : CMD /bin/bash /tmp/exec.sh
 ---> Using cache
 ---> cdb3b9d4f4eb
Step 5/7 : RUN  cat /etc/redhat-release
 ---> Using cache
 ---> e9d9c2eaa408
Step 6/7 : ADD ./conf.d/init.sh /tmp/init.sh
 ---> Using cache
 ---> 1fe3d3924f20
Step 7/7 : RUN ["chmod", "+x", "/tmp/init.sh"]
 ---> Using cache
 ---> c8dacd83403f
Successfully built c8dacd83403f
Successfully tagged iaastool_infra-workflow-manager:latest
Recreating iaastool_infra-workflow-manager_1 ...
Recreating iaastool_infra-workflow-manager_1 ... done
Attaching to iaastool_infra-workflow-manager_1
infra-workflow-manager_1  | Skyfall
infra-workflow-manager_1  | Loaded plugins: fastestmirror, ovl

....

infra-workflow-manager_1  | Skyfall Infra Config Tool
infra-workflow-manager_1  | total 44
infra-workflow-manager_1  | drwxrwxr-x 5 268537125 268537125 4096 Jun  7 16:44 .
infra-workflow-manager_1  | drwxrwxr-x 7 268537125 268537125 4096 Jun  7 15:23 ..
infra-workflow-manager_1  | drwxrwxr-x 2 268537125 268537125 4096 Jun  4 20:55 .draft
infra-workflow-manager_1  | drwxrwxr-x 4 268537125 268537125 4096 Jun  6 14:15 .terraform
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        21 Jun  7 15:30 backend.tf -> ./envs/lab/backend.tf
infra-workflow-manager_1  | drwxrwxr-x 3 268537125 268537125 4096 Jun  5 21:03 envs
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        29 Jun  7 16:44 global-variables.tf -> ../shared/global-variables.tf
infra-workflow-manager_1  | -rw-rw-r-- 1 268537125 268537125   69 Jun  4 20:33 header.tf
infra-workflow-manager_1  | -rw-rw-r-- 1 268537125 268537125  335 Jun  5 22:27 mock.cache-subnet-group.tf
infra-workflow-manager_1  | -rw-rw-r-- 1 268537125 268537125 1369 Jun  6 14:12 mock.network-firewall.tf
infra-workflow-manager_1  | -rw-rw-r-- 1 268537125 268537125 5675 Jun  6 14:22 mock.resource-access-control.tf
infra-workflow-manager_1  | -rw-rw-r-- 1 268537125 268537125  300 Jun  6 14:18 mock.storage-s3-fs-backend.tf
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        21 Jun  7 16:44 provider.tf -> ../shared/provider.tf
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        20 Jun  7 16:44 srv-adm.sh -> ../shared/srv-adm.sh
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        34 Jun  7 15:30 terraform.tfvars -> ./envs/lab/input_parameters.tfvars
infra-workflow-manager_1  | lrwxrwxrwx 1 root      root        21 Jun  7 16:44 versions.tf -> ../shared/versions.tf

```

The **security** service is a privileged workspace that creates all service/end users, access policies and is responsible to allow/deny access control all resources.
Now lets create a service environment (like dev,stage,lab,prod,qa,etc...).
For this edit the docker-compose.yml file and run the start-workflow.sh:

```
    command: ./tmp/init.sh srv-adm security bootstrap lab

```

This will create the ./service/lab/**backend.tf** and **input_parameters.tf** files with empty standard values. Open those files and set the correct values.

```
security/
├── backend.tf -> ./envs/lab/backend.tf
├── envs
│   └── lab
│       ├── backend.tf
│       └── input_parameters.tfvars
├── global-variables.tf -> ../shared/global-variables.tf
├── header.tf
├── provider.tf -> ../shared/provider.tf
├── srv-adm.sh -> ../shared/srv-adm.sh
├── terraform.tfvars -> ./envs/lab/input_parameters.tfvars
└── versions.tf -> ../shared/versions.tf

```

Optionally if you want to create some mock template files for the resource as well run the **cfg-srv** with the **bootstrap** parameter:

For this edit the docker-compose.yml file and run the start-workflow.sh:

```
    command: ./tmp/init.sh cfg-srv bootstrap security

```

This operation will create all the mock* files for the security and network resources:

```
security/
├── backend.tf -> ./envs/lab/backend.tf
├── envs
│   └── lab
│       ├── backend.tf
│       └── input_parameters.tfvars
├── global-variables.tf -> ../shared/global-variables.tf
├── header.tf
├── mock.cache-subnet-group.tf
├── mock.network-firewall.tf
├── mock.resource-access-control.tf
├── mock.storage-s3-fs-backend.tf
├── provider.tf -> ../shared/provider.tf
├── srv-adm.sh -> ../shared/srv-adm.sh
├── terraform.tfvars -> ./envs/lab/input_parameters.tfvars
└── versions.tf -> ../shared/versions.tf


```

For example, lets see the **mock.resource-access-control.tf** file bellow. It creates all required permissions for service/end users to create and manage the given infra. resources.

```
############################
# User/Service Credentials #
# Module: CreateAcessProfile
############################

module "CreateAcessProfile_AdminProfile" {
  source = "../modules/security/ext/auth/CreateAccessProfile"
  username = "admin-user-app-mock"
  namespace = var.namespace
  target_service = "ec2.amazonaws.com"
  access_level = "Allow"
  role_name = "admin-role-app-mock"
}

output "AuthProfile_AdminProfile" {
  value = module.CreateAcessProfile_AdminProfile
}
...

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

  target_resource_id_list = ["s3-fileserver-mock*", "s3-fileserver-mock*"]

  #target_resource_id_list = ["s3-fileserver-mock-${random_integer.value.id}*", "s3-fileserver-mock-${random_integer.value.id}*"]

  region = ""
  account-id = ""

  target_user_name = module.CreateAcessProfile_AdminProfile.aws-user.user.name
  target_role_name = module.CreateAcessProfile_AdminProfile.aws-role.access_role.name
}

output "S3FS_AcessControl_PolicyRule_Adm" {
  value = module.S3FS_GrantAccessTo_ACL_Adm.policy
}


```
Before deploying the resources we need to initialize the service. This operations downloads all modules and configures the backend used to store the required metadata (like tfstate files).

Go back to **utils/iaas-tool/docker-compose.yml**, edit the line and run the **start-workflow**:

```
...

    # create lab environments

    #command: ./tmp/init.sh srv-adm security bootstrap lab
    command: ./tmp/init.sh srv-adm security init lab

...
```

Now lets deploy this workflow in order to create all the security components we need.
Go back to **utils/iaas-tool/docker-compose.yml**, edit the line and run the **start-workflow**:

```
...

    # deploy & remove service environment

    #command: ./tmp/init.sh srv-adm security status lab
    command: ./tmp/init.sh srv-adm security deploy lab
    #command: ./tmp/init.sh srv-adm security remove lab

...
```



### Service: Infra workspace

After creating the security service you have the required service users, roles, permissions and credentials required to deploy infra. resources.
Follow the same steps you did for the security layer but remember to update the **./infra/envs/{backend,input_paraments}.tf** with the service user, storage, credentials, resource-ids, etc created by the *Security* service earlier.
```
    # configure/setup service environment

    #command: ./tmp/init.sh cfg-srv init infra
    
    # create lab environment
    #command: ./tmp/init.sh srv-adm infra bootstrap lab
```

After setting the correct credentials, users and ids you can run each infra. workflow action..

```

    # deploy & remove service environment

    #command: ./tmp/init.sh srv-adm infra status lab
    #command: ./tmp/init.sh srv-adm infra deploy lab
    #command: ./tmp/init.sh srv-adm infra remove lab

```

