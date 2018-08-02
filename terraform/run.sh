#!/bin/bash

echo "Provisioning infrastructure:"

echo "Finding your public address..."
MY_PUBLIC_IP_ADDRESS="$(curl -s ipinfo.io/ip)"
echo "Your public IP address is $MY_PUBLIC_IP_ADDRESS"

echo "Starting Terraform..."
AWS_PROFILE=terraform 
terraform apply -var "my_public_cidr=$MY_PUBLIC_IP_ADDRESS/32" -var "db_password=hibicode"