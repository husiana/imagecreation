This readme needs to be completed somehow.

1- start with login with az-cli, so install it and so on

    1- instal azcli
    2- install packer
    3- install terraform
        echo "Installing terraform ..."
        curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
        apt-add-repository --yes "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        apt-get remove terraform -y
        apt install -y terraform

2- change config

3- run build which should :

    1- Creation of a keyvault
    2- Filling Keyvault randomly
    3- Creation of an image gallery
    4- Creation of image with settings


To do manually ... :

terraform -chdir=./tf init

terraform -chdir=./tf plan

terraform -chdir=./tf apply

terraform -chdir=./tf destroy