#!/usr/bin/env bash
#set -x
ACTION="${1}"
ENVIRONMENT="${2}"
AUTO_INIT=0
LOG_VERBOSE=0
AUTO_APPROVE=1
TARGET="${3}"

if [ $LOG_VERBOSE != 0 ]
then
    #export TF_LOG=DEBUG
    export TF_LOG=ERROR
else
    unset TF_LOG
fi

setup_config () {

        rm backend.tf && rm terraform.tfvars && rm variables.tf
        # rm global-variables.tf.0
        _path=./envs/"${ENVIRONMENT}"/

        if [ -d "$_path" ]; then
          # Control will enter here if $DIRECTORY exists.
            mkdir -p $_path
        fi

        ln -s ${_path}parameters.tf variables.tf
        ln -s ${_path}backend.tf backend.tf
        ln -s ${_path}input_parameters.tfvars terraform.tfvars
        #ln -s mock/mock.ec2std.tf ec2std.tf
        ls -la *.tf *.tfvars

}

bootstrap () {

    mkdir -p ./envs/"${ENVIRONMENT}"/
    echo 'terraform {
  backend "s3" {
    bucket  = "service-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    profile = "service-admin-lab"
  }
}' > ./envs/"${ENVIRONMENT}"/backend.tf

    echo 'profile = "service-admin-lab"
region = "us-east-1"
namespace = "service"
account-id = "0000-0000-0000"
tags = {
    BusinessUnit       = "ACME LTDA"
    ComplianceList     = ""
    ComplianceRequired = "0"
    CriticalLevel      = "9"
    Email              = "l-acme@acme.com"
    EscalationList     = "userid1/userid2/userid3"
    FilaIm             = "l-acme"
    Product            = "ACME Product"
    Slack              = "acme-prod"
    Team               = "acme-devops"
}' > ./envs/"${ENVIRONMENT}"/input_parameters.tfvars

    echo 'variable "my_optional_variable" {
  default = ""
}' > ./envs/"${ENVIRONMENT}"/parameters.tf

    cp ../README.md .

}


case "${ACTION}" in
    "init")
        setup_config
        rm -rf .terraform
        terraform init
        ;;
    "bootstrap")
        bootstrap ;;
    "deploy")
        setup_config
        if [ $AUTO_INIT != 0 ]
        then
            terraform init
        fi

        if [ $AUTO_APPROVE != 0 ]
        then
            terraform apply -auto-approve
        else
            terraform apply
        fi
        ;;

    "list")
        ls -la | grep -e 'input_parameters.tfvars' -e 'backend.tf'
        echo "Enviroments : "
        ls envs ;;
    "remove")
        if [ $AUTO_APPROVE != 0 ]
        then
            terraform destroy -auto-approve
        else
            terraform destroy
        fi
        ;;
    "remove-target")
        if [ $AUTO_APPROVE != 0 ]
        then
            terraform destroy -auto-approve -target $TARGET
        else
            terraform destroy -target $TARGET
        fi
        ;;
    "status")
        terraform plan
        terraform output && tree . ;;

    *)
        echo "Uso: ${0} <init|bootstrap|list|deploy|remove|status> <enviroment>"
        echo "Examples: /srv-adm.sh remove-target lab module.ec2_cluster-freetier"
        exit 1
esac
