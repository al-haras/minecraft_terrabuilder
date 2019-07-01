#!/bin/bash

# Update distro
sudo apt update && sudo apt upgrade -y

#Install unzip
sudo apt-get install unzip -y

# Get Terraform (arm)
wget https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_arm.zip
unzip terraform_0.12.3_linux_arm.zip

# Move to local/bin to run
sudo mv terraform /usr/local/bin

# Create SSH keys
ssh-keygen -f minecraftkey -N ""

# Init Terraform
terraform init

# Plan
terraform plan

# Apply
terraform apply -auto-approve
