#!/bin/bash

echo "Destroying your infrastructure..."

AWS_PROFILE=terraform 
terraform destroy -var "my_public_cidr=10.10.10.10/32" -var "db_password=hibicode"