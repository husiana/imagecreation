#!/bin/bash

set -e
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $THIS_DIR

function check_azcli_version {
  version=$(az --version | grep azure-cli | xargs | cut -d' ' -f 2)
  major=$(echo $version | cut -d'.' -f 1)
  minor=$(echo $version | cut -d'.' -f 2)
  patch=$(echo $version | cut -d'.' -f 3)

  if [[ $major -lt $AZCLI_VERSION_MAJOR ]]
   then
    echo "azure-cli version $AZCLI_VERSION or higher is required"
    exit 1
  else
    if [[ $minor -lt $AZCLI_VERSION_MINOR ]]
     then
      echo "azure-cli version $AZCLI_VERSION or higher is required"
      exit 1
    else
      if [[ $patch -lt $AZCLI_VERSION_PATCH ]]
       then
        echo "azure-cli version $AZCLI_VERSION or higher is required"
        exit 1
      fi
    fi
  fi
}

check_azcli_version

accepted=$(az vm image terms show --offer almalinux-hpc --publisher almalinux --plan 8_5-hpc-gen2 --query 'accepted' -o tsv)
if [[ "$accepted" != "true" ]]
 then
  echo "Azure AlmaLinux marketplace image terms are not accepted, accepting them now"
  az vm image terms accept --offer almalinux-hpc --publisher almalinux --plan 8_5-hpc-gen2 -o tsv
else
  echo "Azure AlmaLinux marketplace image terms already accepted"
fi

user_type=$(az account show --query user.type -o tsv)
export TF_VAR_tenant_id=$(az account show -o json | jq -r .tenantId)
subscription_id=$(az account show --query id -o tsv)

echo User Type is $user_type
echo Tenant ID is $TF_VAR_tenant_id
echo Sub ID is $subscription_id

echo starting with terraform
echo
terraform -chdir=tf/ init -upgrade 

exit $exit_code